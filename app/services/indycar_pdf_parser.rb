class IndycarPdfParser
  # Matches result rows anchored by the C/E/T field (e.g. D/H/F or D/C/F).
  # Captures: (finishing_pos) (car_number) (driver_name)
  ROW_PATTERN = /^\s*(\d+)\s+\d+\s+(\w+)\s+(.+?)\s+D\/[CH]\/F/

  def parse(file)
    reader = PDF::Reader.new(file)
    text = reader.pages.map(&:text).join("\n")

    text.each_line.filter_map do |line|
      m = line.match(ROW_PATTERN)
      next unless m
      {
        finishing_position: m[1].to_i,
        car_number: m[2],
        driver_name: m[3].strip
      }
    end
  end
end
