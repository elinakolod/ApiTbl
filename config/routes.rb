Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :users, only: :create do
        member do
          post :login
        end
      end

      resource :projects, only: %i[create destroy]

      resource :tasks, only: %i[create update destroy]

      resource :comments, only: %i[create destroy]
    end
  end
end
