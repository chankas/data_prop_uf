class UfValue < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates :value, presence: true, numericality: { greater_than: 0 }

  scope :today, -> { find_by(date: Date.current) }
  scope :for_month_of, ->(day) { where(date: day.beginning_of_month..day.end_of_month) }
end
