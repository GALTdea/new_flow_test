Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ], controllers: {
    confirmations: "users/confirmations",
    passwords: "users/passwords",
    sessions: "users/sessions"
  }

  devise_scope :user do
    get "users/sign_up", to: "users/registrations#new", as: :new_user_registration
    post "users", to: "users/registrations#create", as: :user_registration
    get "users/edit", to: "users/registrations#edit", as: :edit_user_registration
    patch "users", to: "users/registrations#update", as: nil
    put "users", to: "users/registrations#update", as: nil
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  if Rails.env.local?
    namespace :development do
      get "ui", to: "ui#show"
    end
  end

  root "home#show"
end
