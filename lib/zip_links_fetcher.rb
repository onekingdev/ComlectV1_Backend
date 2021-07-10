# frozen_string_literal: true

class ZipLinksFetcher
  attr_reader :url

  LINK = '/files/investment/data/information-about-registered-investment-advisers-and-exempt-reporting-advisers/'

  def initialize(url)
    @url = url
  end

  def call
    response = Typhoeus.get(url)
    doc = Nokogiri::HTML(response.body)
    links = doc.css('a').map { |link| link['href'] }
    links = links.select { |link| link&.start_with?(LINK) }.first(2)
    links.map { |link| 'https://www.sec.gov' + link }
  end
end
