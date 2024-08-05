Rails.application.routes.draw do
  resources :availabilities, only: [:index, :update]
  resources :shifts, only: [:index] do
    collection do
      get 'weeks', to: 'shifts#weeks'
    end
  end
  resources :services, only: [:index]
end
