class ProjectMembershipsController < ApplicationController
  before_action :set_project

  def create
    email_or_name = params[:query].to_s.strip
    user = User.find_by(email: email_or_name) || User.find_by(name: email_or_name)

    if user.nil?
      redirect_to @project, alert: "No user found with that name or email."
    elsif @project.members.include?(user)
      redirect_to @project, alert: "#{user.name} is already a member of this project."
    else
      @project.project_memberships.create!(user: user)
      redirect_to @project, notice: "#{user.name} added to the project."
    end
  end

  def destroy
    membership = @project.project_memberships.find(params[:id])
    name = membership.user.name
    membership.destroy
    redirect_to @project, notice: "#{name} removed from the project."
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
