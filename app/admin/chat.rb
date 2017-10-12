ActiveAdmin.register Chat do
  include SharedAdmin
  menu false #label: 'Chat', parent: 'Communicate', priority: 1

  actions :index

  index do
    column :id
    column :created_at
    column :conversation_id
    column 'Conversation Type' do |c|
      c.conversation.conversation_type
    end
    column 'Sender' do |c|
      link_to c.from_user.username , admin_user_path(c.from_user) if c.from_user
    end
    column 'Sender\'s Company' do |c|
      c.from_user.company if c.from_user
    end
    column 'Sender\'s User Type' do |c|
      c.from_user.user_type if c.from_user
    end
    column 'Recipient' do |c|
      if c.from_user_id == c.conversation.from_user_id
        link_to c.recipient.username , admin_user_path(c.recipient) if c.recipient
      elsif c.from_user_id == c.conversation.user_id
        link_to c.conversation.from_user.username , admin_user_path(c.conversation.from_user) if c.conversation.from_user
      end
    end
    column 'Recipient\'s Company' do |c|
      if c.from_user_id == c.conversation.from_user_id
        c.recipient.company if c.recipient
      elsif c.from_user_id == c.conversation.user_id
        c.conversation.from_user.company if c.conversation.from_user
      end
    end
    column 'Recipient\'s User Type' do |c|
      if c.from_user_id == c.conversation.from_user_id
        c.recipient.user_type if c.recipient
      elsif c.from_user_id == c.conversation.user_id
        c.conversation.from_user.user_type if c.recipient
      end
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

  filter :conversation_id, label: 'Conversation Id'
  filter :conversation_name_cont, label: 'Conversation Topic'
  filter :from_user_username_cont, label: 'Sender(Username)'
  filter :from_user_first_name_cont, label: 'Sender(First Name)'
  filter :from_user_last_name_cont, label: 'Sender(Last Name)'
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

  controller do
    def scoped_collection
      super.includes(conversation: [:recipient, :from_user])
    end
  end

end
