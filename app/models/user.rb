# frozen_string_literal: true

class User < ApplicationRecord
  has_many :attachments, dependent: :destroy

  enum role: { admin: 0, job_seeker: 1, employer: 2 }

  validates :name, :email, presence: true
  validates :name, length: { maximum: 150 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
end
