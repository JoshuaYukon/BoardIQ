class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :require_login, unless: :skip_authentication?
  before_action :load_sidebar_boards

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_login
    redirect_to sign_in_path, alert: 'Please sign in to continue.' if current_user.nil?
  end

  def skip_authentication?
    controller_name == 'sessions' ||
      (%w[new create].include?(action_name) && controller_name == 'users')
  end

  def load_sidebar_boards
    return unless current_user
    @sidebar_projects = Project.all.includes(:sprints)

    project_id = detect_sidebar_project_id
    session[:current_project_id] = project_id if project_id

    @current_project = @sidebar_projects.find { |p| p.id == session[:current_project_id].to_i }
    @boards = @current_project ? @current_project.boards : []
  end

  def detect_sidebar_project_id
    return params[:project_id] if params[:project_id].present?
    return params[:id] if params[:controller] == 'projects' && params[:id].present?
    if params[:controller] == 'boards' && params[:id].present?
      Board.where(id: params[:id]).pick(:project_id)
    end
  end
end