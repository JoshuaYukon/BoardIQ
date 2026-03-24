class Activity < ApplicationRecord
  belongs_to :project
  belongs_to :user, optional: true

  scope :recent, -> { order(created_at: :desc).limit(50) }

  def self.log(project:, user:, action:, trackable: nil, description: nil)
    create(
      project: project,
      user: user,
      action: action,
      trackable_type: trackable&.class&.name,
      trackable_id: trackable&.id,
      description: description
    )
  end
end
