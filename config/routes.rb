Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  Rails.application.routes.draw do
    namespace:api do
      namespace:v1 do 
        post '/proxy', to: 'proxy#proxy'
      end
    end
  end
end
