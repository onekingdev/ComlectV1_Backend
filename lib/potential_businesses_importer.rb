class PotentialBusinessesImporter
  attr_reader :zip_links

  URL = 'https://www.sec.gov/help/foiadocsinvafoiahtm.html'.freeze

  def initialize
    @zip_links = ZipLinksFetcher.new(URL).call
  end

  def call
    zip_links.each do |link|
      download_and_parse(link)
    end
  end

  private

  def download_and_parse(zip_file_link)
    input = Typhoeus.get(zip_file_link).body
    Zip::InputStream.open(StringIO.new(input)) do |io|
      while entry = io.get_next_entry
        csv_string = io.read
        encoding_info = CharlockHolmes::EncodingDetector.detect(csv_string)
        csv_string = csv_string.encode('UTF-8', encoding_info[:encoding], invalid: :replace, replace: '')

        pb = CSV.parse(csv_string, headers: true).map do |row|
          build_potential_business_attrs(row.to_h)
        end

        PotentialBusiness.import pb, validate_uniqueness: true
      end
    end
  end

  def build_potential_business_attrs(row)
    {
      crd_number: row['Organization CRD#'],
      business_name: row['Legal Name'],
      website: row['Website Address']&.downcase,
      contact_phone: row['Main Office Telephone Number'].gsub('-',''),
      address_1: row['Main Office Street Address 1'],
      apartment: row['Main Office Street Address 2'],
      city: row['Main Office City'],
      state: row['Main Office State'],
      zipcode: row['Main Office Postal Code'],
      client_account_cnt: row['5F(2)(f)'],
      aum: row['5F(2)(c)']
    }
  end
end
