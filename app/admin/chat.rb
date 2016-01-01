ActiveAdmin.register Chat do
  include SharedAdmin
  menu label: 'Chat Messages', parent: 'Chat', priority: 0

  actions :index

  index do
    column :id
    column :created_at
    column :conversation_id
    column 'From' do |c|
      link_to c.conversation.from_user.full_name , admin_user_path(c.conversation.from_user)
    end
    column 'From Company' do |c|
      c.conversation.from_user.company
    end
    column 'From User Type' do |c|
      c.conversation.from_user.user_type
    end

    column 'To' do |c|
      link_to c.user.full_name , admin_user_path(c.user)
    end
    column 'To Company' do |c|
      c.user.company
    end
    column 'To User Type' do |c|
      c.user.user_type
    end
    column :message
    column :status
    actions do |r|
      (item 'Ban', confirm_status_change_admin_chat_path(r, status_change_action: 'ban'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if r.bannable.active?
      (item 'Enable', confirm_status_change_admin_chat_path(r, status_change_action: 'enable'), class: 'fancybox member_link', data: { 'fancybox-type' => 'ajax' }) if r.bannable.banned?
      (item 'Censor', censor_admin_chat_path(r), class: 'member_link', method: :put) if r.active? || r.allowed?
      (item 'Allow', allow_admin_chat_path(r), class: 'member_link', method: :put) if !r.allowed?
    end
  end

  filter :conversation_id, as: :select, collection: -> {Conversation.all.map{|c| c.id}}
  filter :user
  filter :conversation_from_user
  filter :status, as: :select, collection: Chat.statuses
  filter :message
  filter :created_at

  member_action :censor, method: :put do
    resource.censored!
    redirect_to admin_chats_path, notice: 'Rating Censored!'
  end

  member_action :allow, method: :put do
    resource.allowed!
    redirect_to admin_chats_path, notice: 'Rating Allowed!'
  end

end
