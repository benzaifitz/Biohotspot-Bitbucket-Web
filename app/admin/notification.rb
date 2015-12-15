ActiveAdmin.register Notification do

  actions :index, :new

  filter :created_at
  filter :notification_type, as: :select, collection: -> { Notification.notification_types }

  filter :sent_by_id, label: 'Sender Id'
  filter :sender, as: :select, collection: -> { User.administrator }
  filter :sender_first_name_cont, label: 'Sender First Name'
  filter :sender_last_name_cont, label: 'Sender Last Name'

  filter :user_id, label: 'Recipient Id'
  filter :user_first_name_cont, label: 'Recipient First Name'
  filter :user_last_name_cont, label: 'Recipient Last Name'
  filter :user_type, label: 'Recipient Type',as: :select, collection: -> { User.user_types }
  filter :user, label: 'Recipient'

  filter :subject

  permit_params :subject, :message, :notification_type, :user_id, :user_type

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
      attrs = permitted_params[:notification]
      NotificationQueueJob.perform_later(attrs.merge({ status: Notification.statuses[:created],
                                                       sent_by_id: current_user.id,
                                                       notification_type: attrs[:notification_type].to_i}))
      redirect_to admin_notifications_path,
                  notice: 'Your message(s) has been enqueued for sending! Its status will be changes to Sent or Failed once it has been processed.'
    end
  end
end