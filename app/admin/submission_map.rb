ActiveAdmin.register_page 'Submission map' do
  menu label: 'Submission map', parent: 'Maps'

  content do
    @categories = Category.all.map{|c| [c.name, c.id]}
    render partial: 'index', locals: {categories: @categories}
  end

  page_action :search_submissions, method: :get do
    @submissions = Category.where(id: params[:category_ids]).map(&:sub_categories).flatten.map(&:submissions).flatten rescue []
    render partial: 'populate_map', locals: {submissions: @submissions}
  end

end