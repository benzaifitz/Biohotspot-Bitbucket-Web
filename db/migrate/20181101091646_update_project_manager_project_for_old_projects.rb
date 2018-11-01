class UpdateProjectManagerProjectForOldProjects < ActiveRecord::Migration[5.0]
  def change
    old_projects = Project.where('project_manager_id > ?', 0).select(:id, :project_manager_id)
    old_projects.each do |project|
      begin
        unless ProjectManagerProject.where(project_id: project.id, project_manager_id: project.project_manager_id).first
          ProjectManagerProject.create!(project_id: project.id, project_manager_id: project.project_manager_id, is_admin: true, status: 'accepted')
        end
      rescue
      end
    end
  end
end
