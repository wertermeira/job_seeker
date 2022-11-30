# frozen_string_literal: true

class Attachment < ApplicationRecord
  belongs_to :user

  enum type: { resume: 0, cover_letter: 1, photo: 2 }

  validates :file_path, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
  validates :title, presence: true, length: { maximum: 150 }
end
