if @tutorials.present?
  json.tutorials @tutorials do |tutorial|
    json.extract! tutorial, :id, :avatar_text, :avatar_url
  end
end