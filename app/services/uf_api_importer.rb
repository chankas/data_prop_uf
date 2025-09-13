require "net/http"
require "json"
require "uri"

class UfApiImporter
  API_URL = Rails.application.credentials.uf_api_url
  API_KEY = Rails.application.credentials.uf_api_key

  def initialize(day: nil, month: nil, year: nil)
    @day = day
    @month = month
    @year = year
  end

  def import
    response = fetch_data
    return unless response

    response["UFs"].each do |uf|
      date = Date.strptime(uf["Fecha"], "%Y-%m-%d") rescue next
      value = parse_value(uf["Valor"])

      next unless date && value

      uf_record = UfValue.find_or_initialize_by(date: date)

      if uf_record.new_record?
        uf_record.value = value
        uf_record.save!
      elsif uf_record.value != value
        uf_record.update!(value: value)
      end
      # si es igual, no hacemos nada
    end
  end

  private

  def fetch_data
    uri = URI.parse("#{API_URL}#{date_searches}?apikey=#{API_KEY}&formato=json")
    res = Net::HTTP.get_response(uri)

    return nil unless res.is_a?(Net::HTTPSuccess)

    JSON.parse(res.body)
  rescue StandardError => e
    Rails.logger.error("Error fetching UF API: #{e.message}")
    nil
  end

  def parse_value(valor_str)
    # Convertimos "38.419,17" -> 38419.17
    valor_str.gsub(".", "").gsub(",", ".").to_f rescue nil
  end

  def date_searches
    return "/#{@year}/#{@mont}/dias/#{@day}" if @year.present? && @month.present? && @day.present?
    return "/#{@year}/#{@mont}" if @year.present? && @month.present?
    return "/#{@year}" if @year.present?
    ""
  end
end
