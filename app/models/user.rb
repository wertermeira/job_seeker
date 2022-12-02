# frozen_string_literal: true

class User < ApplicationRecord
  has_many :attachments, dependent: :destroy

  enum role: { admin: 0, job_seeker: 1, employer: 2 }, _prefix: :role

  validates :name, presence: true
  validates :email, presence: true, unless: -> { role_job_seeker? }
  validates :name, length: { maximum: 150 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validate :validate_max_resume, if: -> { role_job_seeker? && email.blank? }

  accepts_nested_attributes_for :attachments, allow_destroy: true

  def attachment_count
    Attachment.kinds.keys.index_with do |i|
      attachment_tally[i] || 0
    end
  end

  private

  def validate_max_resume
    return unless (attachment_tally['resume'] || 0) > 1

    errors.add(:attachments_attributes, I18n.t('errors.messages.require_email_to_multi_attachs'))
  end

  def attachment_tally
    @attachment_tally ||= attachments.map(&:kind).tally
  end
end
