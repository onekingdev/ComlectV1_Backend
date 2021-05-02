class ZipLinksFetcher
  attr_reader :url

  EXEMPT_LINK = '/files/investment/data/information-about-registered-investment-advisers-and-exempt-reporting-advisers/'.freeze
  REGISTERED_LINK = '/files/investment/data/information-about-registered-investment-advisers-and-exempt-reporting-advisers/'.freeze

  def initialize(url)
    @url = url
  end

  def call
    response = Typhoeus.get(url)
    doc = Nokogiri::HTML(response.body)
    links = doc.css('a').map { |link| link['href'] }
    exempt_link = links.select { |link| link&.start_with?(EXEMPT_LINK) }.first
    registered_link = links.select { |link| link&.start_with?(REGISTERED_LINK) }.first
    [exempt_link, registered_link].map { |link| 'https://www.sec.gov' + link }
  end
end
