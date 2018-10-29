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

      api :POST, '/projects/leave', 'Leave project'
      # param :project_id, Integer, desc: 'Id will be of that project which user want to leave'
      def leave
        project = Project.find_by_id(params[:project_id])
        if project
          @msg = 'No other project manager is for this project, so you can\'t leave.'
          pmp = ProjectManagerProject.where(project_id: params[:project_id], project_manager_id: current_user.id, is_admin: true, status: 'accepted').first
          if pmp
            all_pmp = ProjectManagerProject.where(project_id: pmp.project_id, is_admin: true, status: 'accepted').pluck(:id)
            all_pmp.delete(pmp.id)
            if all_pmp.length > 0
              pmp.destroy
              @msg = 'You have left this project successfuly.'
            end
          else
            @msg = 'You are not project admin of this project.'
          end
        else
          @msg = 'Project doesn\'t exist.'
        end
      end

      api :POST, '/projects/join', 'join project'
      # param :project_id, Integer, desc: 'Id will be of that project which user want to leave'
      def join
        project = Project.find_by_id(params[:project_id])
        if project
          @msg = 'You are already part of this project'
          pmp = ProjectManagerProject.where(project_id: params[:project_id], project_manager_id: current_user.id).first
          if (pmp && pmp.status == 'rejected')
            pmp.update_attributes(status: 'pending')
            pr = project.project_requests.create!(user_id: current_user.id, reason: params[:reason] ? params[:reason] : '')
            @msg = 'You have applied for this project'
          end
          unless pmp
            project.project_manager_projects.create!(project_manager_id: current_user.id, is_admin: true, status: 'pending')
            pr = project.project_requests.create!(user_id: current_user.id, reason: params[:reason] ? params[:reason] : '')
            current_user.update_attributes({user_type: 'project_manager'}) if current_user.land_manager?
            @msg = 'You have applied for this project'
          end
        else
          @msg = 'Project doesn\'t exist.'
        end
      end
    end
  end
end