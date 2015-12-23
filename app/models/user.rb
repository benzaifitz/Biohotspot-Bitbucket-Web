# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  eula_id                :integer
#  first_name             :string
#  last_name              :string
#  company                :string
#  rating                 :decimal(, )      default(0.0)
#  status                 :integer          default(0), not null
#  user_type              :integer          default(0), not null
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  tokens                 :json
#  number_of_ratings      :integer          default(0)
#

class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  
  enum user_type: [:staff, :administrator, :customer]
  
  belongs_to :eula
  #belongs_to :user_type
  #belongs_to :user_status
  enum status: [:active, :banned]

  has_many :ratings
  has_many :blocked_users
  has_many :jobs
  has_many :notifications
  has_many :chats
  has_many :conversations
    
  def push_notification(msg)
    uuid = self.uuid_iphone #TODO Add this field to table
    if uuid
      unread_conversation = chats.length # Need to change this
      badge_counter = unread_conversation # add other notifications to counter
      Push::MessageApns.create(
        app: ENV['APP_NAME'],
        device: uuid,
        alert: msg,
        sound: '1.aiff',
        badge: badge_counter,
        expiry: 1.day.to_i,
        attributes_for_device: {
         key: 'MSG',
         unread_conversations: unread_conversation 
        }  
      )
    end
  end
end
