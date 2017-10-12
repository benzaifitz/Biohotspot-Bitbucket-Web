ActiveAdmin.register Conversation do

  menu false #label: 'Conversation', parent: 'Communicate', priority: 0

  actions :index

  index do
    column :id
    column :created_at
    column :conversation_type
    column 'Sender' do |c|
      link_to c.from_user.username , admin_user_path(c.from_user)
    end
    column 'Sender\'s Company' do |c|
      c.from_user.company
    end
    column 'Sender\'s User Type' do |c|
      c.from_user.user_type
    end

    column 'Recipient' do |c|
      if c.direct?
        link_to c.recipient.username , admin_user_path(c.recipient)
      end
    end
    column 'Recipient\'s Company' do |c|
      if c.direct?
        c.recipient.company
      end
    end
    column 'Recipient\'s User Type' do |c|
      if c.direct?
        c.recipient.user_type
      end
    end
    column 'Topic' do |c|
      c.name
    end
    actions do |c|
      item 'Messages', "#{admin_chats_path}?q[conversation_id_eq]=#{c.id}"
    end
  end

  filter :from_user_username_cont, label: 'Sender(Username)'
  filter :from_user_first_name_cont, label: 'Sender(First Name)'
  filter :from_user_last_name_cont, label: 'Sender(Last Name)'
  filter :recipient_username_cont, label: 'Recipient(Username)'
  filter :recipient_first_name_cont, label: 'Recipient(First Name)'
  filter :recipient_last_name_cont, label: 'Recipient(Last Name)'
  filter :created_at
  filter :conversation_type
  filter :name, label: 'Topic'

  controller do
    def scoped_collection
      super.includes(:recipient, :from_user)
    end
  end
end
