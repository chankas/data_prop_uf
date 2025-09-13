class CreateUfValues < ActiveRecord::Migration[8.0]
  def change
    create_table :uf_values do |t|
      t.date :date, null: false, index: true   # Fecha del valor de la UF
      t.decimal :value, precision: 15, scale: 2, null: false  # Valor de la UF con decimales
      t.timestamps
    end
  end
end
