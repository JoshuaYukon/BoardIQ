class User < ApplicationRecord
  has_many :issues
  has_many :comments
  has_many :notifications, dependent: :destroy
  has_many :project_memberships, dependent: :destroy
  has_many :projects, through: :project_memberships
  has_secure_password
end