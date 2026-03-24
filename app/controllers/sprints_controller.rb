class SprintsController < ApplicationController
  before_action :set_sprint, only: [:show, :edit, :update, :destroy, :start, :complete]

  def index
    @project = Project.find(params[:project_id])
    @sprints = @project.sprints.ordered
  end

  def show
    @project = @sprint.project
    @issues = @sprint.issues.includes(:board_state, :user, :board)
    if @sprint.completed?
      last_position = BoardState.where(board_id: @project.board_ids).maximum(:position)
      @completed_issues = @issues.select { |i| i.board_state&.position == last_position }
      @incomplete_issues = @issues.reject { |i| i.board_state&.position == last_position }
    end
  end

  def new
    @project = Project.find(params[:project_id])
    @sprint = @project.sprints.build
    @unassigned_issues = @project.issues.where(sprint_id: nil).includes(:board_state, :board)
    # Pre-select issues belonging to the originating board
    @preselected_issue_ids = params[:board_id].present? ?
      @project.issues.where(sprint_id: nil, board_id: params[:board_id]).pluck(:id) : []
  end

  def create
    @project = Project.find(params[:project_id])
    @board_id = params[:board_id]
    @sprint = @project.sprints.build(sprint_params)

    if @sprint.save
      if params[:issue_ids].present?
        @project.issues.where(id: params[:issue_ids]).update_all(sprint_id: @sprint.id)
      end
      if @board_id.present?
        redirect_to board_path(@board_id), notice: "Sprint \"#{@sprint.name}\" created. Start it when ready."
      else
        redirect_to sprint_path(@sprint), notice: "Sprint created."
      end
    else
      @unassigned_issues = @project.issues.where(sprint_id: nil)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @project = @sprint.project
    @unassigned_issues = @project.issues.where(sprint_id: [nil, @sprint.id])
  end

  def update
    if @sprint.update(sprint_params)
      if params[:issue_ids]
        @sprint.project.issues.where(sprint_id: @sprint.id).update_all(sprint_id: nil)
        @sprint.project.issues.where(id: params[:issue_ids]).update_all(sprint_id: @sprint.id)
      end
      redirect_to sprint_path(@sprint), notice: "Sprint updated."
    else
      @project = @sprint.project
      @unassigned_issues = @project.issues.where(sprint_id: [nil, @sprint.id])
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    project = @sprint.project
    @sprint.issues.update_all(sprint_id: nil)
    @sprint.destroy
    redirect_to project_sprints_path(project), notice: "Sprint deleted."
  end

  def start
    project = @sprint.project
    if project.sprints.active.exists?
      redirect_back fallback_location: project_path(project), alert: "Another sprint is already active. Complete it before starting a new one."
      return
    end
    @sprint.active!
    redirect_back fallback_location: sprint_path(@sprint), notice: "Sprint \"#{@sprint.name}\" is now active."
  end

  def complete
    if @sprint.issues.empty?
      redirect_back fallback_location: sprint_path(@sprint),
        alert: "This sprint has no issues. Add issues via Edit Sprint before completing."
      return
    end
    @sprint.completed!
    redirect_to sprint_path(@sprint), notice: "Sprint \"#{@sprint.name}\" completed. Here is your report."
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end

  def sprint_params
    params.require(:sprint).permit(:name, :goal, :start_date, :end_date)
  end
end
