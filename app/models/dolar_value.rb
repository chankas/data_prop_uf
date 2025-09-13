class DolarValue < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates :value, presence: true, numericality: { greater_than: 0 }

  scope :latest_until_today, -> { where("date <= ?", Date.today).order(date: :desc).first }
end
