Rails.application.routes.draw do
  root to: 'program_selects#index'
  resources(:users, only:[:index, :create, :destroy])

  resources(:program_selects, only: [:index, :show, :create])
  match('/program_selects/confirm', to: 'program_selects#confirm', via: :post)
  match('/program_selects/:id/play', to: 'program_selects#play', via: [:post, :delete])
  match('/program_selects/destroy', to: 'program_selects#destroy_cookie', via: :delete)

  resources(:piston2438_players, only: [:index, :create, :show])
    get('/piston2438_players/next', to: 'piston2438_players_skip#next')

  # routes.rb で利用できる詳細については、https://guides.rubyonrails.org/routing.html をご覧ください。
end
