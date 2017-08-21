ActiveAdmin.register SubCategory do

  menu label: 'Sub Categories List', parent: 'Categories', priority: 2

  permit_params do
    allowed = [:name, :category_id]
    allowed.uniq
  end

  actions :all

end