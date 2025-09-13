
set :output, "log/cron.log"  # Para loguear la salida de los jobs

every 1.day, at: "00:05 am" do
  runner "UfApiImporter.new(day: Date.today.day, month: Date.today.month, year: Date.today.year).import"
end
