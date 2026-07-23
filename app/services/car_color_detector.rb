require "anthropic"

class CarColorDetector
  BATCH_SIZE = 6 # cars per Claude call — balances prompt-overhead savings against response reliability/latency

  BATCH_PROMPT = <<~PROMPT
    You are analyzing IndyCar race car images to determine two livery colors per car, for use as UI button colors (primary/secondary background).

    Above, you were shown one or more cars, each preceded by a "Car #<number>:" label, followed by that car's two images:
    1. A simple colored car-number badge (endplate graphic). This badge may have ONE color or TWO colors (a main number color plus a trim/outline color).
    2. A full side-profile photo of the car's livery, used only as a fallback when the badge doesn't provide enough information.

    The endplate badge is the authoritative source for color identification — it is purpose-built to be clean and readable. Whenever the badge provides a usable color, trust its color reading over the livery photo, even if the livery photo appears to show a slightly different shade. Only use the livery photo to fill in a color the badge doesn't provide (i.e. a missing primary because the badge is black, or a missing secondary because the badge is single-color).

    Determine each car's colors using this exact decision order:

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
    - Evaluate each car independently using only its own two images — do not let one car's colors influence another's.

    Output ONLY valid JSON in this exact format, with no preamble or markdown, with one entry per car in the same order shown above, using the exact car number from each "Car #<number>:" label:

    {
      "cars": [
        {"car_number": "string", "primary_color": {"name": "string", "hex": "#RRGGBB"}, "secondary_color": {"name": "string", "hex": "#RRGGBB"}}
      ]
    }
  PROMPT

  BATCH_COLOR_SCHEMA = {
    type: "object",
    properties: {
      cars: {
        type: "array",
        items: {
          type: "object",
          properties: {
            car_number: { type: "string" },
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
          required: %w[car_number primary_color secondary_color],
          additionalProperties: false,
        },
      },
    },
    required: ["cars"],
    additionalProperties: false,
  }.freeze

  def initialize(client: Anthropic::Client.new)
    @client = client
  end

  # cars: [{ car_number:, driver_id:, image_url:, endplate_url: }, ...] — one Claude call for the whole batch
  def detect_batch(cars)
    return [] if cars.empty?

    content = cars.flat_map { |car|
      [
        { type: "text", text: "Car ##{car[:car_number]}:" },
        { type: "image", source: { type: "url", url: car[:endplate_url] } },
        { type: "image", source: { type: "url", url: car[:image_url] } },
      ]
    }
    content << { type: "text", text: BATCH_PROMPT }

    response = @client.messages.create(
      model: "claude-opus-4-8",
      max_tokens: 4096,
      output_config: { format_: { schema: BATCH_COLOR_SCHEMA } },
      messages: [{ role: "user", content: content }],
    )

    text_block = response.content.find { |block| block.type == :text }
    by_car_number = JSON.parse(text_block.text)["cars"].index_by { |c| c["car_number"].to_s }

    cars.map { |car|
      result = by_car_number[car[:car_number].to_s]
      next car.merge(color_error: "No result returned for this car") unless result

      primary = result["primary_color"]
      secondary = result["secondary_color"]
      # The prompt forbids black as primary, but batched calls occasionally mix this up
      # across cars — enforce it in code rather than trusting the model every time.
      primary, secondary = secondary, primary if black?(primary) && !black?(secondary)

      car.merge(
        primary_color: primary["hex"],
        primary_color_name: primary["name"],
        secondary_color: secondary["hex"],
        secondary_color_name: secondary["name"],
      )
    }
  rescue => e
    cars.map { |car| car.merge(color_error: e.message) }
  end

  private

  def black?(color)
    color["name"].to_s.downcase.include?("black")
  end
end
