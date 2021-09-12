class Category < ApplicationRecord
  self.table_name = 'categories'

  has_many(:programs, class_name: 'Program')
end
