Rails.application.routes.draw do
  root "home#index"
  get "/filter_date", to: "home#index", as: :filter_date
end
