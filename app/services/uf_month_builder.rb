class UfMonthBuilder
  def initialize(date)
    @date = date
  end

  def build
    last_day  = @date.end_of_month
    days_count = last_day.day
    UfApiImporter.new(year: @date.year, month: @date.month).import if UfValue.for_month_of(@date).count == 0
    ufs = UfValue.for_month_of(@date).index_by { |uf| uf.date.day }
    (1..days_count).map { |day| ufs[day] }
  end
end
