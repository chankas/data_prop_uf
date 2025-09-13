class HomeController < ApplicationController
  before_action :set_uf_today
  def index
    puts @uf_today
  end

  private

  def set_uf_today
    @uf_today = UfValue.today
  end
end
