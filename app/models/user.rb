# frozen_string_literal: true

class User < ApplicationRecord
  has_many :attachments, dependent: :destroy

  enum role: { admin: 0, job_seeker: 1, employer: 2 }, _prefix: :role

  validates :name, presence: true
  validates :email, presence: true, unless: -> { role_job_seeker? }
  validates :name, length: { maximum: 150 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :validate_max_resume, if: -> { role_job_seeker? &&  email.blank? }

  accepts_nested_attributes_for :attachments, allow_destroy: true

  def attachment_count
    attachments.map { |attach| attach.kind  }.tally
  end

  private

  def validate_max_resume
    resumes = attachments.map { |attach| attach.kind  }.tally['resume'] || 0
    errors.add(:attachments_attributes, 'to add more resumes. email is required') if resumes > 1
  end
end
