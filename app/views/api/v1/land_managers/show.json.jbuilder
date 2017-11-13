if @land_manager.present?
  json.partial! "api/v1/land_managers/land_manager", land_manager: @land_manager
end
