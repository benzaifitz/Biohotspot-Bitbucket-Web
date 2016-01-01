CarrierWave.configure do |config|
  config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     Rails.application.secrets.aws_access_key_id,
      aws_secret_access_key: Rails.application.secrets.aws_secret_access_key,
      region:                'ap-southeast-2'
  }
  config.fog_directory  = 'framework-dev'
  config.fog_public     = true
  config.fog_attributes = { 'Cache-Control' => "max-age=315576000" }
end