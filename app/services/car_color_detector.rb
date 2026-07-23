require "anthropic"

class CarColorDetector
  PROMPT = <<~PROMPT
    You are analyzing IndyCar race car images to determine two livery colors for use as UI button colors (primary/secondary background).

    You will receive two images:
    1. A simple colored car-number badge (endplate graphic). This badge may have ONE color or TWO colors (a main number color plus a trim/outline color).
    2. A full side-profile photo of the car's livery, used only as a fallback when the badge doesn't provide enough information.

    The endplate badge is the authoritative source for color identification — it is purpose-built to be clean and readable. Whenever the badge provides a usable color, trust its color reading over the livery photo, even if the livery photo appears to show a slightly different shade. Only use the livery photo to fill in a color the badge doesn't provide (i.e. a missing primary because the badge is black, or a missing secondary because the badge is single-color).

    Determine the colors using this exact decision order:

    STEP 1 — Determine primary color:
    - Look at the endplate badge's main/dominant color (the number itself, not a thin outline or trim).
    - If that color is NOT black, use it as the primary color, matching the hex as closely as possible to the badge's own color (not the livery photo's version of that color).
    - If that color IS black, ignore the badge for primary purposes and instead determine the primary color from the full livery photo: identify the most visually dominant color on the car's bodywork (nose, sidepods, engine cover, rear wing), excluding black, white, and gray unless one of them is the only strong color present. Black may never be chosen as primary.

    STEP 2 — Determine secondary color:
    - Check the endplate badge for a second color (e.g. an outline, trim, or accent color around the number, distinct from the main number color).
    - If a second badge color exists, use it as the secondary color, matching the hex to the badge's own color. This may be black — black is allowed as secondary.
    - If the badge has only one color (no trim/outline color), then look at the full livery photo and find its most dominant body color, and use that as the secondary color instead. This may also be black if black truly is the most dominant body color.

    Additional rules:
    - If a color is a pale/light blue, silver-blue, or icy blue tone, classify it as "blue" rather than silver or gray.
    - Return colors as hex codes that closely match the actual color seen — not idealized/pure hex values.
    - Primary and secondary must be two distinct colors when possible.

    Output ONLY valid JSON in this exact format, with no preamble or markdown:

    {
      "primary_color": {"name": "string", "hex": "#RRGGBB"},
      "secondary_color": {"name": "string", "hex": "#RRGGBB"}
    }
  PROMPT

  COLOR_SCHEMA = {
    type: "object",
    properties: {
      primary_color: {
        type: "object",
        properties: { name: { type: "string" }, hex: { type: "string" } },
        required: %w[name hex],
        additionalProperties: false,
      },
      secondary_color: {
        type: "object",
        properties: { name: { type: "string" }, hex: { type: "string" } },
        required: %w[name hex],
        additionalProperties: false,
      },
    },
    required: %w[primary_color secondary_color],
    additionalProperties: false,
  }.freeze

  def initialize(client: Anthropic::Client.new)
    @client = client
  end

  def detect(endplate_url:, livery_url:)
    response = @client.messages.create(
      model: "claude-opus-4-8",
      max_tokens: 1024,
      output_config: { format_: { schema: COLOR_SCHEMA } },
      messages: [{
        role: "user",
        content: [
          { type: "image", source: { type: "url", url: endplate_url } },
          { type: "image", source: { type: "url", url: livery_url } },
          { type: "text", text: PROMPT },
        ],
      }],
    )

    text_block = response.content.find { |block| block.type == :text }
    parsed = JSON.parse(text_block.text)

    {
      primary_color: parsed.dig("primary_color", "hex"),
      primary_color_name: parsed.dig("primary_color", "name"),
      secondary_color: parsed.dig("secondary_color", "hex"),
      secondary_color_name: parsed.dig("secondary_color", "name"),
    }
  end
end
