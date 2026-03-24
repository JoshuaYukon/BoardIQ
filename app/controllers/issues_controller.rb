class IssuesController < ApplicationController
  before_action :set_issue, only: %i[ show edit update destroy move assign_sprint ]

  # GET /issues or /issues.json
  def index
    @issues = Issue.all
  end

  # GET /issues/1 or /issues/1.json
  def show
  end

  # GET /issues/new
  def new
    board = Board.find_by(id: params[:board_id])
    @issue = Issue.new(
      board_id: params[:board_id],
      board_state_id: params[:board_state_id],
      project_id: board&.project_id,
      user_id: current_user&.id
    )
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues or /issues.json
  def create
    @issue = Issue.new(issue_params)

    respond_to do |format|
      if @issue.save
        Activity.log(project: @issue.project, user: current_user, action: "created issue", trackable: @issue, description: @issue.title)
        tab = @issue.board_state_id.nil? ? "backlog" : "board"
        format.html { redirect_to board_path(@issue.board, tab: tab), notice: "Issue was successfully created." }
        format.json { render :show, status: :created, location: @issue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issues/1 or /issues/1.json
  def update
    # Purge individually removed attachments before saving new ones
    if params[:remove_attachment_ids].present?
      @issue.attachments.where(id: params[:remove_attachment_ids]).each(&:purge)
    end
    respond_to do |format|
      if @issue.update(issue_params)
        Activity.log(project: @issue.project, user: current_user, action: "updated issue", trackable: @issue, description: @issue.title)
        format.html { redirect_to @issue, notice: "Issue was successfully updated." }
        format.json { render :show, status: :ok, location: @issue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @issue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /issues/1/move (drag-and-drop or backlog → board)
  def move
    moving_to_backlog = params[:board_state_id].blank?
    attrs = { board_state_id: params[:board_state_id].presence }
    attrs[:sprint_id] = nil if moving_to_backlog
    @issue.update(attrs)
    respond_to do |format|
      format.json { head :ok }
      format.html { redirect_back fallback_location: board_path(@issue.board) }
    end
  end

  # PATCH /issues/1/assign_sprint
  def assign_sprint
    @issue.update(sprint_id: params[:sprint_id].presence)
    redirect_back fallback_location: board_path(@issue.board)
  end

  # DELETE /issues/1 or /issues/1.json
  def destroy
    board = @issue.board
    @issue.destroy

    respond_to do |format|
      format.html { redirect_to board_url(board), notice: "Issue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def issue_params
      params.require(:issue).permit(:title, :description, :status, :board_state_id, :sprint_id, :project_id, :user_id, :board_id, attachments: [])
    end
end