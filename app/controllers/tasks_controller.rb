class TasksController < ApplicationController
  before_action :set_issue
  before_action :set_task, only: [:edit, :update, :destroy, :toggle]

  def create
    @task = @issue.tasks.build(task_params)
    @task.position = Task.find_max_position(@issue.id) + 1

    if @task.save
      redirect_to @issue, notice: 'Task created successfully.'
    else
      redirect_to @issue, alert: 'Error creating task.'
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to @issue, notice: 'Task updated successfully.'
    else
      redirect_to @issue, alert: 'Error updating task.'
    end
  end

  def toggle
    @task.toggle!(:completed)
    redirect_to @issue, notice: "Task marked as #{@task.completed? ? 'completed' : 'incomplete'}."
  end

  def destroy
    @task.destroy
    redirect_to @issue, notice: 'Task deleted successfully.'
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :completed)
  end
end
