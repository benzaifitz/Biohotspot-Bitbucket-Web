if @category.present?
    json.extract! @category, :id, :name, :description, :tags, :class_name, :family, :location, :url, :site_id, :created_at, :updated_at
end
