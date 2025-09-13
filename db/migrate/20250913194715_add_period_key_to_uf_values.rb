class AddPeriodKeyToUfValues < ActiveRecord::Migration[8.0]
  def up
    add_column :uf_values, :period_key, :string
    UfValue.reset_column_information
    UfValue.find_each do |uf|
      uf.update_column(:period_key, uf.date.strftime("%Y-%m"))
    end
    change_column_null :uf_values, :period_key, false
    add_index :uf_values, :period_key
  end

  def down
    remove_index :uf_values, :period_key
    remove_column :uf_values, :period_key
  end
end
