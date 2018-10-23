json.array! @projects do |project|
  json.extract! project, :id, :title, :summary, :status, :access_status, :created_at, :updated_at
end