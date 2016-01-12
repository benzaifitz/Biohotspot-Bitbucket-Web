ActiveAdmin.register Conversation do

  menu label: 'Conversation', parent: 'Chat', priority: 0

  actions :index

  index do
    column :id
    column :created_at
    column :conversation_type
    column 'From' do |c|
      link_to c.from_user.full_name , admin_user_path(c.from_user)
    end
    column 'From Company' do |c|
      c.from_user.company
    end
    column 'From User Type' do |c|
      c.from_user.user_type
    end

    column 'To' do |c|
      if c.direct?
        link_to c.recipient.full_name , admin_user_path(c.recipient)
      end
    end
    column 'To Company' do |c|
      if c.direct?
        c.recipient.company
      end
    end
    column 'To User Type' do |c|
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

  filter :from_user
  filter :user
  filter :created_at
  filter :conversation_type
  filter :name, label: 'Topic'

end
