class Program < ApplicationRecord
  self.table_name = 'programs'

  belongs_to(:category, class_name: 'Category', foreign_key: 'category_id')
end
