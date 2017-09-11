if @land_manager.present?
  json.partial! "api/v1/land_managers/land_manager", land_manager: @land_manager
  json.set! 'sub_categories' do
    json.array!(@land_manager.sub_categories) do |sc|
      json.partial! "api/v1/land_managers/sub_category", sub_category: sc
    end
  end
end
