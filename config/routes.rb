# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # resources :tasks, except: %i[new edit], param: :slug, defaults: { format: 'json' }
  # resources :users, only: :index

  # defaults format: :json do
  #   resources :tasks, except: %i[new edit], param: :slug
  #   resources :users, only: :index
  # end

  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end

  draw :sidekiq

  constraints(lambda { |req| req.format == :json }) do
    resources :tasks, except: %i[new edit], param: :slug
    resources :users, only: %i[index create]
    resource :session, only: :create
    resource :session, only: [:create, :destroy]
    resources :comments, only: :create

    resource :preference, only: %i[show update] do
      patch :mail, on: :collection
    end

    resources :tasks, except: %i[new edit], param: :slug do
      collection do
        resource :report, only: %i[create], module: :tasks do
          get :download, on: :collection
        end
      end
    end

  end

  root "home#index"
  get "*path", to: "home#index", via: :all
end
