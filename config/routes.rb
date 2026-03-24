Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :notifications, only: [:index]
  
  get '/sign_in', to: 'sessions#new'
  delete '/sign_out', to: 'sessions#destroy'
  
  get '/invitations/accept', to: 'invitations#accept', as: 'accept_invitation'

  resources :projects do
    resources :boards do
      resources :board_states
    end
    resources :sprints, only: [:index, :new, :create]
    resources :invitations, only: [:new, :create]
    resources :project_memberships, only: [:create, :destroy]
  end
  
  resources :boards do
    resources :board_states
  end

  resources :issues do
    member do
      patch :move
      patch :assign_sprint
    end
    resources :comments
    resources :tasks do
      member do
        patch :toggle
      end
    end
  end

  resources :sprints do
    member do
      patch :start
      patch :complete
    end
  end

  scope '/ai' do
    post 'generate_description', to: 'ai#generate_description'
    post 'suggest_breakdown',    to: 'ai#suggest_breakdown'
    post 'suggest_priority',     to: 'ai#suggest_priority'
    post 'summarize_sprint',     to: 'ai#summarize_sprint'
  end

  root "projects#index"
end