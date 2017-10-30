ActiveAdmin.register_page 'Maps' do
  menu label: 'Maps', priority: 8

  content do
    @categories = Category.all.map{|c| [c.name, c.id]}
    @sub_categories = SubCategory.all.map{|c| [c.project_location_site_prefix_name, c.id]}
    @sites = Site.all.map{|c| [c.project_location_prefix_name, c.id]}
    @locations = Location.all.map{|c| [c.project_prefix_name, c.id]}
    @projects = Project.all.map{|c| [c.title, c.id]}
    render partial: 'index', locals: {categories: @categories, sites: @sites, locations: @locations,
                                      projects: @projects,
                                      sub_categories: @sub_categories}
  end

  page_action :search_submissions, method: :get do
    @submissions = Submission.ransack(params[:q]).result.to_a
    # submission_ids = Category.where(id: params[:category_ids]).map(&:sub_categories).flatten.map(&:submission).compact.flatten.map(&:id) rescue []
    # @submissions = Submission.where(id: submission_ids).where.not(latitude: nil, longitude: nil) rescue []
    render partial: 'populate_map', locals: {submissions: @submissions}
  end


end