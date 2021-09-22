class Program < ApplicationRecord
  self.table_name = 'programs'

  belongs_to(:category, class_name: 'Category', foreign_key: 'category_id')

  def get_all_mixes
    return Program.where(category_id: category_id).select(:id, :on_air).reorder('on_air DESC').readonly
  end

  def get_period_mixes
    return Program.where(on_air: on_air, category_id: category_id).select(:id, :on_air).reorder('on_air DESC').readonly
  end
end
