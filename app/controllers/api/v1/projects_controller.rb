module Api
  module V1
    class ProjectsController < ApiController
      before_action :authenticate_user!
      #GET /api/v1/project.json
      api :GET, '/projects.json', 'Return a list of associated and open projects'
      def index
        if params[:assignedProjects] && params[:assignedProjects] == true.to_s
          pm = ProjectManager.find_by_id(current_user.id)
          @projects = pm ? pm.projects.where(status: 'open') : []
          @projects.each do |project|
            project.access_status = 'accepted'
          end
        else
          pm_projects = ProjectManagerProject.where(project_manager_id: current_user.id)
          project_statuses = pm_projects.pluck(:status)
          project_ids = pm_projects.pluck(:project_id)
          @projects = Project.where(status: 'open')
          @projects.each do |project|
            project_ids.index(project.id).nil? ? project.access_status = 'available' : project.access_status = project_statuses[project_ids.index(project.id)]
          end
        end
      end

      api :GET, '/projects/1/species.json', 'Returns species data'
      def species
        project = Project.find_by_id(params[:project_id])
        @specie_types = get_grouped_categories(project)
      end

      def get_grouped_categories(project)
        category_types = []
        SpecieType.joins(:categories).where("categories.id IN (?)",project.categories.ids).order("name asc").uniq.each do |st|
          categories = st.categories.order("name asc").group_by { |d| d[:family_common] }
          categories.each do |family, categories_group|
            type_hash = {
                type: [st.name, family].join(", "),
                categories: []
            }
            categories_group.each do |category|
              type_hash[:categories] << category
            end
            category_types << type_hash
          end
        end
        category_types
      end
    end
  end
end