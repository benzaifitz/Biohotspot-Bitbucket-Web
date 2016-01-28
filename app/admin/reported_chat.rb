ActiveAdmin.register ReportedChat do
  include SharedAdmin

  menu label: 'Reported Messages', parent: 'User Content', priority: 2

  actions :index

  index do
    column :created_at
    column 'Reported By' do |r|
      link_to r.reported_by.username, admin_user_path(r.reported_by)
    end
    column 'Reported By Company' do |r|
      label r.reported_by.company
    end
    column 'Reported By User Type' do |r|
      label r.reported_by.user_type
    end
    column 'Message Created At' do |r|
      r.chat.created_at
    end
    column :chat_id

    column 'Sender' do |r|
      link_to r.chat.from_user.username , admin_user_path(r.chat.from_user) if r.chat.from_user
    end
    column 'Sender\'s Company' do |r|
      r.chat.from_user.company if r.chat.from_user
    end
    column 'Sender\'s User Type' do |r|
      r.chat.from_user.user_type if r.chat.from_user
    end
    column 'Message' do |r|
      r.chat.message
    end
    column 'Status' do |r|
      r.chat.status
    end

    actions do |r|
      (item 'Ban', confirm_status_change_admin_reported_chat_path(r, status_change_action: 'ban'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if r.bannable.active?
      (item 'Enable', confirm_status_change_admin_reported_chat_path(r, status_change_action: 'enable'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if r.bannable.banned?
      (item 'Censor', censor_admin_reported_chat_path(r), class: 'member_link', method: :put) if r.chat.active? || r.chat.allowed?
      (item 'Allow', allow_admin_reported_chat_path(r), class: 'member_link', method: :put) if !r.chat.allowed?
    end
  end

  member_action :censor, method: :put do
    resource.chat.censored!
    redirect_to admin_reported_chats_path, notice: 'Chat Censored!'
  end

  member_action :allow, method: :put do
    resource.chat.allowed!
    redirect_to admin_reported_chats_path, notice: 'Chat Allowed!'
  end

  filter :reported_by_username_cont, label: 'Reported By(Username)'
  filter :reported_by_first_name_cont, label: 'Reported By(First Name)'
  filter :reported_by_last_name_cont, label: 'Reported By(Last Name)'
  filter :created_at, label: 'Reported At'


  controller do
    def scoped_collection
      super.includes(:reported_by, chat: :from_user)
    end
  end
end
