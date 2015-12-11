ActiveAdmin.register Notification do

  actions :index, :new

  filter :created_at
  filter :notification_type, as: :select, collection: Notification.notification_types

  filter :sent_by_id, label: 'Sender Id'
  filter :sender, as: :select, collection: User.administrator
  filter :sender_first_name_cont, label: 'Sender First Name'
  filter :sender_last_name_cont, label: 'Sender Last Name'

  filter :user_id, label: 'Recipient Id'
  filter :user_first_name_cont, label: 'Recipient First Name'
  filter :user_last_name_cont, label: 'Recipient Last Name'
  filter :user_type, label: 'Recipient Type',as: :select, collection:  User.user_types
  filter :user, label: 'Recipient'

  filter :subject

  permit_params :user_id, :user_type, :subject, :message

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
      notification.status.capitalize
    end
    column (:subject) do |notification|
      truncate notification.subject
    end
    column (:message) do |notification|
      truncate notification.message.gsub(/<\/?[^>]*>/, "")
    end
    column '' do |notification|
      link_to 'View', admin_notification_path(notification), class: 'fancybox member-link', data: { 'fancybox-type' => 'ajax' }
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
      input :notification_type, as: :select, collection: Notification.notification_types,
            selected: Notification.notification_types[:email], include_blank: false
      input :subject, required: true
      input :message, required: true, as: :ckeditor
    end
    actions
  end

  controller do
    def scoped_collection
      super.includes :user, :sender
    end

    def show
      @notification = Notification.find(params[:id])
      @recipient = @notification.user
      @sender = @notification.sender
      render :layout => false
    end

    def create
      notification_params = params[:notification]
      if notification_params[:user_id].present?
        user = User.find(notification_params[:user_id])
        notification = Notification.create!(user_id: user.id, user_type: user[:user_type], message: notification_params[:message],
                          subject: notification_params[:subject], notification_type: notification_params[:notification_type].to_i, status: Notification.statuses[:created], sent_by_id: current_user.id)
      else
        user_group_type = User.user_types.key(notification_params[:user_type].to_i)
        NotificationQueueJob.perform_later(current_user.id, user_group_type, notification_params[:message], notification_params[:subject],notification_params[:notification_type].to_i)
        notifications_queued = true
      end

      if notifications_queued || notification.persisted?
        redirect_to admin_notifications_path,
                    notice: 'Your message(s) has been enqueued for sending! Its status will be changes to Sent or Failed once it has been processed.'
      else
        flash[:error] = 'Some errors occured while sending message!'
        redirect_to admin_notifications_path
      end
    end
  end
end