require 'rails_helper'

RSpec.describe UfApiImporter, type: :service do
  let(:valid_api_response) do
    {
      "UFs" => [
        { "Fecha" => "2025-07-01", "Valor" => "38.419,17" },
        { "Fecha" => "2025-07-02", "Valor" => "38.421,65" }
      ]
    }
  end

  before do
    allow(Net::HTTP).to receive(:get_response).and_return(
      instance_double(Net::HTTPSuccess, is_a?: true, body: valid_api_response.to_json)
    )
  end

  describe "#import" do
    context "creación de registros" do
      it "crea nuevos registros" do
        expect { UfApiImporter.new(year: 2025, month: 7).import }
          .to change(UfValue, :count).by(2)
      end
    end

    context "registros existentes" do
      before do
        create(:uf_value, date: Date.new(2025, 7, 1), value: 38419.17)
        create(:uf_value, date: Date.new(2025, 7, 2), value: 11111)
      end

      it "actualiza solo los registros con valor distinto" do
        UfApiImporter.new(year: 2025, month: 7).import
        expect(UfValue.find_by(date: Date.new(2025, 7, 1)).value).to eq(38419.17)
        expect(UfValue.find_by(date: Date.new(2025, 7, 2)).value).to eq(38421.65)
      end
    end

    context "día específico" do
      it "importa solo el registro del día indicado" do
        UfApiImporter.new(year: 2025, month: 7, day: 2).import
        expect(UfValue.exists?(date: Date.new(2025, 7, 1))).to be_falsey
        expect(UfValue.exists?(date: Date.new(2025, 7, 2))).to be_truthy
      end
    end

    context "API falla" do
      it "no lanza error" do
        allow(Net::HTTP).to receive(:get_response).and_raise(StandardError.new("Falla API"))
        expect { UfApiImporter.new.import }.not_to raise_error
        expect(UfValue.count).to eq(0)
      end
    end

    context "fechas o valores inválidos" do
      it "ignora registros inválidos" do
        response = {
          "UFs" => [
            { "Fecha" => "abc", "Valor" => "38.000,00" },
            { "Fecha" => "2025-07-01", "Valor" => "abc" },
            { "Fecha" => "2025-07-02", "Valor" => "38.421,65" }
          ]
        }
        allow(Net::HTTP).to receive(:get_response).and_return(
          instance_double(Net::HTTPSuccess, is_a?: true, body: response.to_json)
        )

        UfApiImporter.new.import
        expect(UfValue.count).to eq(1)
        expect(UfValue.find_by(date: Date.new(2025, 7, 2)).value).to eq(38421.65)
      end
    end
  end
end
