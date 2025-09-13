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
    return unless response && response["UFs"].is_a?(Array)

    response["UFs"].each do |uf|
      date = parse_date(uf["Fecha"])
      value = parse_value(uf["Valor"])

      next unless date && value
      next if filter_date?(date) == false
      next unless value && value > 0

      uf_record = UfValue.find_or_initialize_by(date: date)

      if uf_record.new_record?
        uf_record.value = value
        uf_record.save!
      elsif uf_record.value != value
        uf_record.update!(value: value)
      end
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
    valor_str.to_s.gsub(".", "").gsub(",", ".").to_f rescue nil
  end

  def parse_date(date_str)
    Date.strptime(date_str.to_s, "%Y-%m-%d") rescue nil
  end

  def filter_date?(date)
    return false if @year && date.year != @year.to_i
    return false if @month && date.month != @month.to_i
    return false if @day && date.day != @day.to_i
    true
  end

  def date_searches
    segments = []
    segments << @year.to_s if @year.present?
    segments << @month.to_s if @month.present?
    segments << "dias/#{@day}" if @day.present? && @month.present? && @year.present?
    segments.empty? ? "" : "/" + segments.join("/")
  end
end
