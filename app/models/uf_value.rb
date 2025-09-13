class UfValue < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :period_key, presence: true

  before_validation :set_period_key

  after_commit :invalidate_cache

  scope :for_day, ->(day) do
    Rails.cache.fetch("uf_value/day/#{day}", expires_in: 24.hours) do
      find_by(date: day)
    end
  end

  scope :for_month_of, ->(date) do
    key = date.strftime("%Y-%m")
    Rails.cache.fetch("uf_value/month/#{key}", expires_in: 24.hours) do
      where(period_key: key).to_a
    end
  end

  private

  def set_period_key
    self.period_key = date&.strftime("%Y-%m")
  end

  def invalidate_cache
    # Borrar cache de día
    Rails.cache.delete("uf_value/day/#{date}")

    # Borrar cache del mes
    Rails.cache.delete("uf_value/month/#{period_key}")
  end
end
