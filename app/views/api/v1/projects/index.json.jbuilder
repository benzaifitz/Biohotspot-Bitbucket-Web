json.deprecated_eula Eula.find_by_is_latest(true).id != current_user.eula_id
json.projects @projects do |project|
  json.extract! project, :id, :title, :summary, :status, :access_status, :created_at, :updated_at
end