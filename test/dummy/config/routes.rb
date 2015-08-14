Rails.application.routes.draw do

  mount PaymentIcons::Engine => "/payment_icons"

  get '/icon', to: 'icons#show'
end
