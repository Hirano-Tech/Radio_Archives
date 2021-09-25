Rails.application.routes.draw do
  root to: 'program_selects#index'

  resources(:sessions, path: 'user/sessions', only:[:index, :create, :destroy])
  resources(:registrations, path: 'user/registrations', only:[:index, :new, :create])
    delete('user/registrations/destroy', to: 'registrations#destroy')

  resources(:program_selects, only: :index)
  resource(:players, only: :show)

  # routes.rb で利用できる詳細については、https://guides.rubyonrails.org/routing.html をご覧ください。
end
