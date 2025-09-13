
# Guardar logs del cron
set :output, "#{path}/log/cron.log"

# Forzar bash login para cargar rbenv (Ruby 3.3.7)
set :job_template, "/bin/bash -l -c ':job'"

# =============================
# Cron diario: importar UF
# =============================
every 1.day, at: "00:05 am" do
  runner "UfApiImporter.new(day: Date.today.day, month: Date.today.month, year: Date.today.year).import"
end

# =============================
# Cron diario: importar Dólar
# =============================
every 1.day, at: "00:10 am" do
  runner "DolarApiImporter.new(day: Date.today.day, month: Date.today.month, year: Date.today.year).import"
end
