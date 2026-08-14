class TierPasteParser
  def parse(text)
    lines = text.to_s.split("\n").map { |line| line.split("\t", -1) }

    header = lines.first
    has_header = header && header.first.to_s.strip.match?(/\ATier\s*1\z/i)
    lines.shift if has_header

    tier_count = has_header ? header.length : lines.map(&:length).max.to_i

    rows = []
    (0...tier_count).each do |col_index|
      tier_number = col_index + 1
      lines.each do |cells|
        name = cells[col_index].to_s.strip
        next if name.empty?

        driver = find_driver(name)
        rows << {
          tier_number: tier_number,
          driver_name: name,
          driver_id: driver&.id,
          matched: driver.present?
        }
      end
    end
    rows
  end

  private

  def find_driver(name)
    Driver.find_by(name: name) || Driver.find_by("name ILIKE ?", name)
  end
end
