Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "static_pages/home", to: "static_pages#home"
  get "static_pages/help", to: "static_pages#help"
end
