ActiveAdmin.register Notification do

  actions :index

  filter :created_at
  filter :notification_type, as: :select, collection: Notification.notification_types

  filter :sent_by_id, label: 'Sender Id'
  filter :sender, as: :select, collection: User.administrators
  filter :sender_first_name_cont, label: 'Sender First Name'
  filter :sender_last_name_cont, label: 'Sender Last Name'

  filter :user_id, label: 'Recipient Id'
  filter :user_first_name_cont, label: 'Recipient First Name'
  filter :user_last_name_cont, label: 'Recipient Last Name'
  filter :user_type, label: 'Recipient Type',as: :select, collection:  User.user_types
  filter :user, label: 'Recipient'

  filter :subject

  index do
    selectable_column
    id_column
    column :created_at
    column 'Notification Type' do |notification|
      notification.notification_type
    end
    column 'Sent By', :sender
    column 'Recipient', :user
    column 'Recipient User type' do |notification|
      notification.user.user_type
    end
    column 'Status' do |notification|
      notification.status
    end
    column (:subject) {|notification| truncate notification.subject }
    column (:message) {|notification| truncate notification.message }
    column '' do |notification|
      link_to 'View', admin_notification_path(notification), class: 'fancybox member-link', data: { 'fancybox-type' => 'ajax' }
    end
  end

  member_action :show, :method => :get do
    @notification = Notification.find(params[:id])
    render :layout => false
  end
end