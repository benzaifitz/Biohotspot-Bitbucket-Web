json.extract! land_manager, :status,:approved,:id,:email,:provider,:user_type,:mobile_number,:uid,
              :name,:eula_id,:first_name,:last_name,:company,:rating,:number_of_ratings,:username,:device_token,
              :device_type,:uuid_iphone,:privacy_id,:project_id,:managed_project_id, :sign_in_count
json.profile_picture land_manager.profile_picture.serializable_hash
json.aws_access_key_id Rails.application.secrets.aws_access_key_id
json.aws_secret_access_key Rails.application.secrets.aws_secret_access_key
json.aws_s3_bucket Rails.application.secrets.s3_bucket
json.aws_s3_region Rails.application.secrets.s3_region
json.fcm_server_key Rails.application.secrets.fcm_server_key