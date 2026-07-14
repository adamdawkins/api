Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      get "/projects/:api_id" => "projects#show", as: :project
      patch "/projects/:api_id/finance/decline" => "projects/finance#decline", as: :finance_decline
      patch "/projects/:api_id/finance/approve" => "projects/finance#approve", as: :finance_approve
    end
  end
end
