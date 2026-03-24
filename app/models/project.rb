class Project < ApplicationRecord
  has_many :issues, dependent: :destroy
  has_many :boards, dependent: :destroy
  has_many :sprints, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :project_invitations, dependent: :destroy
  has_many :project_memberships, dependent: :destroy
  has_many :members, through: :project_memberships, source: :user
end