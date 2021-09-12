Rails.application.routes.draw do
  resources(:users, only:[:index, :create, :destroy])

  resources(:program_selects, only: [:index, :show, :create])
  match('/program_selects/confirm', to: 'program_selects#confirm', via: :post)
  match('/program_selects/:id/play', to: 'program_selects#play', via: [:post, :delete])
  match('/program_selects/destroy', to: 'program_selects#destroy_cookie', via: :delete)

  # routes.rb で利用できる詳細については、https://guides.rubyonrails.org/routing.html をご覧ください。
end
