class CreateDolarValues < ActiveRecord::Migration[8.0]
  def change
    create_table :dolar_values do |t|
      t.date :date, null: false, index: true   # Fecha del valor del Dolar
      t.decimal :value, precision: 15, scale: 2, null: false  # Valor del Dolar con decimales
      t.timestamps
    end
  end
end
