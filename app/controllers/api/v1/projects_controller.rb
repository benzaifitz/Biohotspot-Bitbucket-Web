module Api
  module V1
    class ProjectsController < ApiController
      before_action :authenticate_user!
      #GET /api/v1/project.json
      api :GET, '/projects.json', 'Return a list of associated and open projects'
      def index
        if params[:assignedProjects] && params[:assignedProjects] == true
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
        @species = project ? project.categories : []
      end
    end
  end
end