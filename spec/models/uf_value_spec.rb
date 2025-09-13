require 'rails_helper'

RSpec.describe UfValue, type: :model do
  it "tiene una factory válida" do
    uf = build(:uf_value)
    expect(uf).to be_valid
  end

  it "no es válido sin fecha" do
    uf = build(:uf_value, date: nil)
    expect(uf).not_to be_valid
  end

  it "no es válido sin valor" do
    uf = build(:uf_value, value: nil)
    expect(uf).not_to be_valid
  end
end
