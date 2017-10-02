# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email

if Rails.env.development? && Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name).nil?
  app = Rpush::Apns::App.new
  app.name = Rails.application.secrets.app_name
  app.certificate = File.read("#{Rails.root}/config/certs/DevCertificate.pem")
  app.environment = 'development'
  app.password = nil
  app.connections = 1
  app.save!
end



if Rails.env.development? && Rpush::Gcm::App.find_by_name(Rails.application.secrets.app_name).nil?
  app = Rpush::Gcm::App.new
  app.name = Rails.application.secrets.app_name
  app.auth_key = "AAAA4IwHR_Y:APA91bErtbassc09ho4V_AGym9_cRKPLO6UCfngEStsSYWSmJ0Mu3fn8ErLHTFt_gBzDajbiehVgEAiyGDJCYhtLmNU7XbQGyociaHJYMS8ri2qolnw8HY38uGLN-vGFFWamYMesrGM3"
  app.connections = 1
  app.save!
end

if Rails.env.production? && Rpush::Apns::App.find_by_name(Rails.application.secrets.app_name).nil?
  app = Rpush::Apns::App.new
  app.name = Rails.application.secrets.app_name
  app.certificate = File.read("#{Rails.root}/config/certs/distribution.pem")
  app.environment = 'production'
  app.password = 'test1234'
  app.connections = 1
  app.save!
end
