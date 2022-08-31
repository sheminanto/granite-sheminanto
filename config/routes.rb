# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # resources :tasks, except: %i[new edit], param: :slug, defaults: { format: 'json' }
  # resources :users, only: :index

  # defaults format: :json do
  #   resources :tasks, except: %i[new edit], param: :slug
  #   resources :users, only: :index
  # end

  constraints(lambda { |req| req.format == :json }) do
    resources :tasks, except: %i[new edit], param: :slug
    resources :users, only: %i[index create]
    resource :session, only: :create
    resource :session, only: [:create, :destroy]
    resources :comments, only: :create
  end

  root "home#index"
  get "*path", to: "home#index", via: :all
end
