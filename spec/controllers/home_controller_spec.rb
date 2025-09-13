require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    let!(:uf_today) { create(:uf_value, date: Date.today, value: 12345.67) }

    it "asigna @uf_today" do
      get :index
      expect(assigns(:uf_today)).to eq(uf_today)
    end

    context "cuando no se pasan params" do
      it "asigna @date_filter como nil" do
        get :index
        expect(assigns(:date_filter)).to be_nil
      end

      it "no construye @ufs_for_month" do
        get :index
        expect(assigns(:ufs_for_month)).to be_nil
      end
    end

    context "cuando se pasan year y month válidos" do
      let(:year) { 2025 }
      let(:month) { 9 }

      it "asigna @date_filter correctamente" do
        get :index, params: { year: year, month: month }
        expect(assigns(:date_filter)).to eq(Date.new(year, month, 1))
      end

      it "construye @ufs_for_month usando el service" do
        expect(UfMonthBuilder).to receive(:new).with(Date.new(year, month, 1)).and_call_original
        get :index, params: { year: year, month: month }
        expect(assigns(:ufs_for_month)).to be_a(Array)
      end
    end

    context "cuando los params son inválidos" do
      it "asigna @date_filter como nil" do
        get :index, params: { year: "abc", month: nil }
        expect(assigns(:date_filter)).to be_nil
      end
    end
  end
end
