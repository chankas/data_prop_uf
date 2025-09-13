FactoryBot.define do
  factory :uf_value do
    date { Date.today }
    value { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
  end
end
