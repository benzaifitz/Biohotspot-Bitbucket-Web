ActiveAdmin.register RpushNotification, as: 'Email/Push Notification' do

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
  filter :user_username_cont, label: 'Recipient Username'
  filter :user_user_type_eq, label: 'Recipient Usertype', as: :select, collection: -> { User.user_types }


  filter :device_token_present, as: :boolean, label: 'Include Push Notifications', default: true
  filter :device_token_blank,   as: :boolean, label: 'Include Email Notifications', default: true

  filter :delivered
  filter :failed

  filter :alert

  permit_params :alert, :user_id, :user_type, :notification_type, :category

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
    column :notification_type
    column 'Subject', :category
    column (:message) do |notification|
      truncate notification.alert.gsub(/<\/?[^>]*>/, "")
    end
    column 'Actions' do |nt|
      link_to 'View', admin_email_push_notification_path(nt), class: 'fancybox member-link', data: { 'fancybox-type' => 'ajax' }
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
      input :notification_type, as: :select, collection: RpushNotification::NOTIFICATION_TYPE, include_blank: false, selected: params[:notification_type]
      input :category, label: 'Subject', hint: 'Not needed for push notifications.'
      input :alert, label: 'Message', required: true, as: :ckeditor, hint: 'Formatting will be discarded in case of push notifications.'
    end
    f.actions do
      f.action :submit, label: "Create #{params[:notification_type].try(:capitalize)} Notification"
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
      render template: 'admin/notifications/show', layout: false
    end

    def create
      attrs = permitted_params[:rpush_notification]
      if attrs[:alert].present?
        RpushNotificationQueueJob.perform_later(attrs.merge({sent_by_id: current_user.id}))
        redirect_to admin_email_push_notifications_path,
                  notice: 'Your message(s) has been enqueued for sending! Its status will be changes to Sent or Failed once it has been processed.'
      else
        flash[:error] = "Message is mandatory."
        redirect_to new_admin_email_push_notification_path(@rpush_notification)
      end
    end
  end
end
