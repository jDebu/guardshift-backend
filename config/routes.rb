Rails.application.routes.draw do
  resources :availabilities, only: [:index, :update]
  resources :shifts, only: [:index]
end
