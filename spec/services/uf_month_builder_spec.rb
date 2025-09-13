require 'rails_helper'

RSpec.describe UfMonthBuilder, type: :service do
  describe "#build" do
    let(:date) { Date.new(2025, 9, 1) } # ejemplo de septiembre 2025
    let(:builder) { described_class.new(date) }

    it "devuelve un array con la misma cantidad de días del mes" do
      result = builder.build
      expect(result.size).to eq(date.end_of_month.day)
    end

    it "coloca los registros en la posición correcta del día" do
      # Crear algunos registros de prueba
      create(:uf_value, date: Date.new(2025, 9, 1), value: 11111)
      create(:uf_value, date: Date.new(2025, 9, 5), value: 55555)
      create(:uf_value, date: Date.new(2025, 9, 30), value: 30303)

      result = builder.build

      expect(result[0].value).to eq(11111)   # día 1
      expect(result[4].value).to eq(55555)   # día 5
      expect(result[29].value).to eq(30303)  # día 30

      # días sin registro deben ser nil
      expect(result[1]).to be_nil
      expect(result[28]).to be_nil
    end
  end
end
