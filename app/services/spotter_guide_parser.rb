require "net/http"

class SpotterGuideParser
  LIVERY_IMAGE_PATTERN = %r{(?<path>/[\w\-/]*Liveries/[\w\-]+/(?<car_number>\d+)-[\w\-]+\.(?:png|jpg|jpeg))}i

  def parse(url)
    uri = URI.parse(url)
    html = Net::HTTP.get(uri)

    html.scan(LIVERY_IMAGE_PATTERN).map { |path, car_number|
      { car_number: car_number, image_url: absolute_url(uri, path) }
    }.uniq { |row| row[:car_number] }
  end

  private

  def absolute_url(page_uri, path)
    return path if path.start_with?("http")

    "#{page_uri.scheme}://#{page_uri.host}#{path}"
  end
end
