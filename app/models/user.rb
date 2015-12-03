class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
  belongs_to :eula
  #belongs_to :user_type
  #belongs_to :user_status
  
  has_many :ratings
  has_many :blocked_users
  has_many :jobs
  has_many :notifications
  has_many :chats
  has_many :conversations
  
end
