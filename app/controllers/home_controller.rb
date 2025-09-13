class HomeController < ApplicationController
  before_action :set_uf_today
  def index
    @date_filter = day_by(params[:year], params[:month])
    @ufs_for_month = UfMonthBuilder.new(@date_filter).build if @date_filter.present?
  end

  private

def day_by(year, month)
  return unless year && month && year.present?
  Date.new(year.to_i, month.to_i, 1) rescue nil
end

  def set_uf_today
    @uf_today = UfValue.today
  end
end
