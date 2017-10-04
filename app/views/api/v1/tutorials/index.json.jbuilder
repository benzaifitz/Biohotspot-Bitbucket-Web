if @tutorials.present?
  json.deprecated_eula deprecated_eula
  json.tutorials @tutorials do |tutorial|
    json.extract! tutorial, :id, :avatar_text, :avatar_url
  end
end