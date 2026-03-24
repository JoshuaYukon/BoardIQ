class BoardStatesController < ApplicationController
  before_action :set_board
  before_action :set_board_state, only: [:edit, :update, :destroy]

  def index
    @board_states = @board.board_states.ordered
  end

  def new
    @board_state = @board.board_states.build
  end

  def create
    @board_state = @board.board_states.build(board_state_params)
    @board_state.position = BoardState.where(board_id: @board.id).maximum(:position).to_i + 1

    if @board_state.save
      redirect_to @board, notice: 'State created successfully.'
    else
      redirect_to @board, alert: 'Error creating state.'
    end
  end

  def edit
  end

  def update
    if @board_state.update(board_state_params)
      redirect_to @board, notice: 'State updated successfully.'
    else
      redirect_to @board, alert: 'Error updating state.'
    end
  end

  def destroy
    @board_state.destroy
    redirect_to @board, notice: 'State deleted successfully.'
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_board_state
    @board_state = BoardState.find(params[:id])
  end

  def board_state_params
    params.require(:board_state).permit(:name, :color)
  end
end
