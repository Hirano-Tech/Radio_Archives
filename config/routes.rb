Rails.application.routes.draw do
  root to: 'program_selects#index'

  resources(:users, only:[:index, :create, :destroy])
  resources(:piston2438_players, only: [:index, :create, :show])
  resources(:program_selects, only: [:index, :show, :create, :destroy])
  match('/program_selects/confirm', to: 'program_selects#confirm', via: :post)
  match('/program_selects/:id/play', to: 'program_selects#play', via: [:post, :delete])

  # routes.rb で利用できる詳細については、https://guides.rubyonrails.org/routing.html をご覧ください。
end
