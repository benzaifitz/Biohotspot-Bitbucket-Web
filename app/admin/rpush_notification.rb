ActiveAdmin.register RpushNotification, as: 'Push Notifications' do

  menu label: 'Notifications List', parent: 'Notifications', priority: 0

  actions :index, :new

  filter :created_at

  filter :sent_by_id, label: 'Sender Id'
  filter :sender, as: :select, collection: -> { User.administrator }
  filter :sender_first_name_cont, label: 'Sender First Name'
  filter :sender_last_name_cont, label: 'Sender Last Name'

  filter :user_id, label: 'Recipient Id'
  filter :user_first_name_cont, label: 'Recipient First Name'
  filter :user_last_name_cont, label: 'Recipient Last Name'
  filter :user, label: 'Recipient'

  filter :delivered
  filter :failed

  filter :alert

  permit_params :alert, :user_id, :user_type

  index do
    selectable_column
    id_column
    column :created_at
    column 'Sent By', :sender
    column 'Recipient' do |notification|
      link_to notification.user.username, admin_user_path(notification.user)
    end
    column 'Recipient User type' do |notification|
      notification.user.user_type
    end
    column :delivered
    column :delivered_at
    column :failed
    column :failed_at
    column (:message) do |notification|
      truncate notification.alert
    end
    column 'Actions' do |nt|
      link_to 'View', admin_push_notification_path(nt), class: 'fancybox member-link', data: { 'fancybox-type' => 'ajax' }
    end
  end

  form do |f|
    panel 'Note' do
      "If you provide a User Id the message will be sent to that user only. If you want to send a message to a group you will have to specify the user group type."
    end
    inputs 'Details' do
      semantic_errors
      input :user_id, label: 'User Id'
      input :user_type, label: 'Group Type', as: :select, collection: User.user_types,
            selected: User.user_types[:staff], include_blank: false
      input :alert, required: true, as: :text
    end
    f.actions do
      f.action :submit, label: 'Create Push Notification'
      f.cancel_link(admin_users_path)
    end
  end

  controller do
    def scoped_collection
      super.includes :user, :sender
    end

    def show
      @notification = RpushNotification.find(params[:id])
      @recipient = @notification.user
      @sender = @notification.sender
      render template: 'admin/notifications/show', :layout => false
    end

    def create
      attrs = permitted_params[:rpush_notification]
      if attrs[:alert].present?
        RpushNotificationQueueJob.perform_later(attrs.merge({sent_by_id: current_user.id}))
        redirect_to admin_push_notifications_path,
                  notice: 'Your message(s) has been enqueued for sending! Its status will be changes to Sent or Failed once it has been processed.'
      else
        flash[:error] = "Alert message is mandatory"
        redirect_to new_admin_push_notification_path
      end
    end
  end
end
