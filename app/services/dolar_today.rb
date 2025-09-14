class DolarToday
  def initialize
  end
  def get
    today = Date.today
    Rails.cache.fetch("dolar_value/day/#{today}", expires_in: 24.hours) do
      dolar_value = DolarValue.latest_until_today

      # Si el último registro es de hoy → devolvemos directamente
      if dolar_value&.date == today
        dolar_value
      else
        # Importamos desde API
        DolarApiImporter.new(day: today.day, month: today.month, year: today.year).import
        # Volvemos a consultar el valor (puede ser nuevo o el mismo)
        DolarValue.latest_until_today
      end
    end
  end
end
