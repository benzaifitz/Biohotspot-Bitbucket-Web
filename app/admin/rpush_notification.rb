ActiveAdmin.register Rpush::Client::ActiveRecord::Notification, as: 'Notification' do

  menu label: 'Notifications List', parent: 'Communication', priority: 9

  config.clear_action_items!

  action_item :view, only: :index do
    link_to 'Email Notification', "#{new_admin_notification_path}?notification_type=#{RpushNotification::NOTIFICATION_TYPE[:email]}"
  end
  action_item :view, only: :index do
    link_to 'Push Notification',  "#{new_admin_notification_path}?notification_type=#{RpushNotification::NOTIFICATION_TYPE[:push]}"
  end


  filter :created_at

  filter :sent_by_id, label: 'Sender Id'
  filter :sender, as: :select, collection: -> { User.administrator }
  filter :sender_username_cont, label: 'Sender(Username)'
  filter :sender_first_name_cont, label: 'Sender(First Name)'
  filter :sender_last_name_cont, label: 'Sender(Last Name)'

  filter :user_id, label: 'Recipient Id'
  filter :user_username_cont, label: 'Recipient(Username)'
  filter :user_first_name_cont, label: 'Recipient(First Name)'
  filter :user_last_name_cont, label: 'Recipient(Last Name)'
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
      link_to(notification.user.username, admin_user_path(notification.user)) rescue nil
    end
    column 'Recipient User type' do |notification|
      notification.user.user_type rescue nil
    end
    column :delivered
    column :delivered_at
    column :failed
    column :failed_at
    column :notification_type
    column 'Subject' do |r|
      r.notification['title'] rescue nil
    end
    column (:notification) do |r|
      r.notification['body'] rescue nil
    end
    column 'Actions' do |nt|
      link_to 'View', admin_notification_path(nt), class: 'fancybox member-link', data: { 'fancybox-type' => 'ajax' }
    end
  end

  form do |f|
    panel 'Note' do
      "If you provide a User Id the message will be sent to that user only. If don't specify user id message will be send to all land managers."
    end
    inputs 'Details' do
      semantic_errors
      input :user_id, label: 'User Id'
      input :user_type, label: 'Group Type', as: :select, collection: User.user_types, include_blank: false
      input :notification_type, as: :hidden, input_html: { value: params[:notification_type] }
      if params[:notification_type] == RpushNotification::NOTIFICATION_TYPE[:email]
        input :category, label: 'Subject'
        input :alert, label: 'Message', required: true, as: :ckeditor
      elsif params[:notification_type] == RpushNotification::NOTIFICATION_TYPE[:push]
        input :alert, label: 'Message', required: true
      end
    end
    f.actions do
      f.action :submit, label: "Create #{params[:notification_type].try(:capitalize)} Notification"
      f.cancel_link(admin_notifications_path)
    end
  end

  controller do

    def new 
      params[:notification_type] ||= 'email'
      super
    end  
    
    def scoped_collection
      super.where.not(user_id: nil)
    end

    def show
      @notification = RpushNotification.find(params[:id])
      @recipient = @notification.user
      @sender = @notification.sender
      render template: 'admin/notifications/show', layout: false
    end

    def create
      permitted_params[:rpush_client_active_record_notification][:notification_type] ||= 'email'
      attrs = permitted_params[:rpush_client_active_record_notification]
      if attrs[:alert].present?
        RpushNotificationQueueJob.perform_later(attrs.merge({sent_by_id: current_user.id, user_type: User.user_types[:land_manager]}).to_json)
        redirect_to admin_notifications_path,
                  notice: 'Your message(s) has been enqueued for sending! Its Delivered or Failed field will be set to true once it has been processed.'
      else
        flash[:error] = "Message is mandatory."
        redirect_to "#{new_admin_notification_path(@rpush_notification)}?notification_type=#{attrs[:notification_type]}"
      end
    end
  end
end
