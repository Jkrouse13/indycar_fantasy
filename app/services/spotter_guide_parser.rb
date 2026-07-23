require "net/http"

class SpotterGuideParser
  LIVERY_IMAGE_PATTERN = %r{(?<path>/[\w\-/]*Liveries/[\w\-]+/(?<car_number>\d+)-[\w\-]+\.(?:png|jpg|jpeg))}i
  ENDPLATE_IMAGE_PATTERN = %r{(?<path>/[\w\-/]*Endplates/Color-Trans/(?<car_number>\d+)-[\w]+-T\.(?:png|jpg))}i

  def parse(url)
    uri = URI.parse(url)
    html = Net::HTTP.get(uri)

    endplates = html.scan(ENDPLATE_IMAGE_PATTERN).each_with_object({}) { |(path, car_number), h|
      h[car_number] ||= absolute_url(uri, path)
    }

    html.scan(LIVERY_IMAGE_PATTERN).map { |path, car_number|
      { car_number: car_number, image_url: absolute_url(uri, path), endplate_url: endplates[car_number] }
    }.uniq { |row| row[:car_number] }
  end

  private

  def absolute_url(page_uri, path)
    return path if path.start_with?("http")

    "#{page_uri.scheme}://#{page_uri.host}#{path}"
  end
end
