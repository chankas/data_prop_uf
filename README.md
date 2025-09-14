# DataProp UF

Aplicación en **Ruby on Rails** para consultar, almacenar y visualizar los valores de la **UF (Unidad de Fomento)** y su conversión a dólares.  
El proyecto incluye integración con API externa, almacenamiento en **PostgreSQL**, cache con **Solid Cache**, y visualización en dos modos: **tabla** y **calendario**.

- Puedes verlo en https://data-prop-uf.onrender.com/

---

## 📥 Descarga

Clonar repositorio:

```bash
git clone https://github.com/chankas/data_prop_uf
cd data_prop_uf
```

---

## ⚙️ Instalación

### Requisitos previos
- Ruby `3.3.7`
- Rails `8.0.2.1`
- PostgreSQL
- Bundler >= `2.7.2`

### Instalación de dependencias
```bash
bundle install
```

### Configuración de base de datos
El proyecto en producción usa una sola base de datos para **datos, cache, queue y cable**.

Editar `config/database.yml` con tus credenciales de PostgreSQL.  
Luego ejecutar:

```bash
bin/rails db:setup
bin/rails db:migrate
```

---

## 🔑 Configuración de credenciales

Configurar API externa en `config/credentials.yml.enc`:

```yaml
dolar_api_url: https://api.sbif.cl/api-sbifv3/recursos_api/dolar
uf_api_url: https://api.sbif.cl/api-sbifv3/recursos_api/uf
uf_api_key: [puedes obtenerla desde https://api.sbif.cl/uso-de-api-key.html]
```

Editar con:

```bash
bin/rails credentials:edit
```

---

## 💻 Despliegue en desarrollo

Levantar servidor local:

```bash
bin/dev
```

Abrir en el navegador:

```bash
  http://localhost:3000/
```

Ejecutar pruebas:

```bash
bundle exec rspec
```

---

## 🔄 Cron Jobs (importación automática de UF)

El proyecto usa la gema **whenever** para importar diariamente la UF.

- Se ejecuta **todos los días a medianoche (00:05) y (00:10)**.
- El log se guarda en: `log/cron.log`.

Ejemplo de entrada generada en crontab:

```bash
0 0 * * * /bin/bash -l -c 'cd /path/to/project && bundle exec bin/rails runner -e production '\''DolarApiImporter.new(day: Date.today.day, month: Date.today.month, year: Date.today.year).import'\'' >> log/cron.log 2>&1'
```

---

## 🛠️ Funcionalidades generales

- 📊 **Importación automática** de valores de UF desde API externa.  
- 💾 Almacenamiento en **PostgreSQL** con control de duplicados.  
- 🔄 **Cache** con `Rails.cache` usando **Solid Cache**.  
- 📅 Visualización de datos en modo **tabla** y **calendario**.  
- 🔍 Filtros por mes y año.  
- ⏰ Actualización automática con cron job.  
- 🧪 Tests unitarios e integración con RSpec.  
- 🎨 Interfaz con **Bootstrap** e íconos dinámicos.  
- ⚡ Alternancia de vistas (tabla ↔ calendario) con **StimulusJS**.  


