require 'rails_helper'

RSpec.describe DolarValue, type: :model do
  it "tiene una factory válida" do
    dolar = build(:dolar_value)
    expect(dolar).to be_valid
  end

  it "no es válido sin fecha" do
    dolar = build(:dolar_value, date: nil)
    expect(dolar).not_to be_valid
  end

  it "no es válido sin valor" do
    dolar = build(:dolar_value, value: nil)
    expect(dolar).not_to be_valid
  end
end
