class UfMonthBuilder
  def initialize(date)
    @date = date
  end

  def build
    first_day = @date
    last_day  = first_day.end_of_month
    days_count = last_day.day

    ufs = UfValue.for_month_of(first_day).index_by { |uf| uf.date.day }

    (1..days_count).map { |day| ufs[day] }
  end
end
