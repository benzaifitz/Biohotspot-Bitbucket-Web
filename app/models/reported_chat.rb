class ReportedChat < ActiveRecord::Base
  belongs_to :chat
  belongs_to :reported_by, class_name: "User", foreign_key: "reported_by_id"
end
