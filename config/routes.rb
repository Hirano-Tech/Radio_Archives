Rails.application.routes.draw do
  resources(:program_selects, only: [:index, :show, :create])
  match('/program_selects/confirm', to: 'program_selects#confirm', via: :post)

  # routes.rb で利用できる詳細については、https://guides.rubyonrails.org/routing.html をご覧ください。
end
