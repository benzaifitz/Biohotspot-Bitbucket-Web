# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = CreateAdminService.new.call
puts 'CREATED ADMIN USER: ' << user.email

if Rpush::Apns::App.find_by_name("framework").nil?
  app = Rpush::Apns::App.new
  app.name = 'framework'
  app.certificate = File.read("#{Rails.root}/config/certs/fram-apns-dev.pem")
  app.environment = 'sandbox' # APNs environment.
  app.password = nil
  app.connections = 1
  app.save!
end

if Rpush::Gcm::App.find_by_name("framework").nil?
  app = Rpush::Gcm::App.new
  app.name = "framework"
  app.auth_key = Rails.application.secrets.gcm_api_key
  app.connections = 1
  app.save!
end
