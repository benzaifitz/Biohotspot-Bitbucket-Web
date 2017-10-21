class AddSiteToUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :site_id, :integer
    User.all.each do |u|
      if u.sub_categories.first && u.sub_categories.first.category && u.sub_categories.first.category.site
        u.update_column(:site_id, u.sub_categories.first.category.site.id)
      end
    end
  end
  def down
    remove_column :users, :site_id
  end
end
