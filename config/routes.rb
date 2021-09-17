Rails.application.routes.draw do
  root to: 'program_selects#index'

  resources(:sessions, path: 'user/sessions', only:[:index, :create, :destroy])
  resources(:registrations, path: 'user/registrations', only:[:index, :new, :create])
    delete('user/registrations/destroy', to: 'registrations#destroy')

  resources(:program_selects, only: [:index, :show, :create, :destroy])
    match('/program_selects/confirm', to: 'program_selects#confirm', via: :post)
    match('/program_selects/:id/play', to: 'program_selects#play', via: [:post, :delete])
  resources(:piston2438_players, only: [:index, :create, :show])
  # routes.rb で利用できる詳細については、https://guides.rubyonrails.org/routing.html をご覧ください。
end
