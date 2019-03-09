Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :users, only: :create do
        member do
          post :login
        end
      end
    end
  end
end
