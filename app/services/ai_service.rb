class AiService
  MODEL = "claude-sonnet-4-6"

  def self.client
    @client ||= Anthropic::Client.new(api_key: ENV.fetch("ANTHROPIC_API_KEY", nil))
  end

  def self.call(prompt)
    return "AI is not configured. Set ANTHROPIC_API_KEY to enable AI features." unless ENV["ANTHROPIC_API_KEY"].present?

    response = client.messages(
      model: MODEL,
      max_tokens: 1024,
      messages: [{ role: "user", content: prompt }]
    )
    response.content.first.text
  rescue => e
    "AI request failed: #{e.message}"
  end

  def self.generate_description(title)
    call("You are a project management assistant. Write a clear, concise issue description (2-4 sentences) for a task titled: \"#{title}\". Be specific about what needs to be done and any acceptance criteria. Respond with just the description, no intro text.")
  end

  def self.suggest_breakdown(title, description)
    call("You are a project management assistant. Break down this issue into 3-6 concrete subtasks.\n\nIssue: #{title}\nDescription: #{description}\n\nRespond with a numbered list of subtasks only, one per line, no extra text.")
  end

  def self.suggest_priority(issues_summary)
    call("You are a project management assistant. Given these open issues, suggest a priority order and brief reasoning.\n\nIssues:\n#{issues_summary}\n\nRespond with a numbered priority list, one issue per line with a short reason (max 1 sentence each).")
  end

  def self.summarize_sprint(sprint_name, goal, issues)
    done = issues.select { |i| i.board_state&.position == issues.filter_map { |x| x.board_state&.position }.max }
    in_progress = issues - done
    call("You are a project management assistant. Summarize this sprint's progress.\n\nSprint: #{sprint_name}\nGoal: #{goal}\nTotal issues: #{issues.count}\nCompleted: #{done.count}\nIn progress/other: #{in_progress.count}\nIssue titles: #{issues.map(&:title).join(', ')}\n\nWrite a concise 2-3 sentence sprint summary for a manager. Include what was achieved and any blockers.")
  end
end
