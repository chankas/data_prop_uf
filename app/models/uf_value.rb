class UfValue < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates :value, presence: true, numericality: { greater_than: 0 }
  validates :period_key, presence: true

  scope :today, -> { find_by(date: Date.current) }
  scope :for_month_of, ->(date) { where(period_key: date.strftime("%Y-%m")) }

  before_validation :set_period_key

  private
  def set_period_key
    self.period_key = date&.strftime("%Y-%m")
  end
end
