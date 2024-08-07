Rails.application.routes.draw do
  scope '/backend' do
    resources :availabilities, only: [:index, :create]
    resources :shifts, only: [:index] do
      collection do
        get 'weeks', to: 'shifts#weeks'
      end
    end
    resources :services, only: [:index]
  end
end
