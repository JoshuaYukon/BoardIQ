class AiController < ApplicationController
  def generate_description
    title = params[:title].to_s.strip
    render json: { result: AiService.generate_description(title) }
  end

  def suggest_breakdown
    issue = Issue.find(params[:issue_id])
    result = AiService.suggest_breakdown(issue.title, issue.description.to_plain_text)
    render json: { result: result }
  end

  def suggest_priority
    project = Project.find(params[:project_id])
    max_pos = project.issues.filter_map { |i| i.board_state&.position }.max || 0
    open_issues = project.issues.includes(:board_state).select { |i| (i.board_state&.position || -1) < max_pos }
    summary = open_issues.map { |i| "- #{i.title} (#{i.board_state&.name || 'No status'})" }.join("\n")
    render json: { result: AiService.suggest_priority(summary) }
  end

  def summarize_sprint
    sprint = Sprint.find(params[:sprint_id])
    issues = sprint.issues.includes(:board_state)
    result = AiService.summarize_sprint(sprint.name, sprint.goal, issues.to_a)
    render json: { result: result }
  end
end
