ActiveAdmin.register_page 'Maps', namespace: :pm do
  menu label: 'Maps', priority: 9

  content do
    @categories = current_project_manager.categories.pluck(:name, :id)
    @sub_categories = current_project_manager.sub_categories.map{|c| [c.project_location_site_prefix_name, c.id]}
    @sites = current_project_manager.sites.map{|c| [c.project_location_prefix_name, c.id]}
    @locations = current_project_manager.locations.map{|c| [c.project_prefix_name, c.id]}
    @projects = current_project_manager.projects.pluck(:title, :id)
    render partial: 'index', locals: {categories: @categories, sites: @sites, locations: @locations,
                                      projects: @projects,
                                      sub_categories: @sub_categories}
  end

  page_action :search_submissions, method: :get do
    @submissions = Submission.ransack(params[:q]).result.where.not(latitude: [nil,0.0]).where.not(longitude: [nil,0.0]).to_a
    # submission_ids = Category.where(id: params[:category_ids]).map(&:sub_categories).flatten.map(&:submission).compact.flatten.map(&:id) rescue []
    # @submissions = Submission.where(id: submission_ids).where.not(latitude: nil, longitude: nil) rescue []
    render partial: 'populate_map', locals: {submissions: @submissions}
  end


end