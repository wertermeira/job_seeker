# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :user_role, :attachment_count, :created_at, :updated_at
  has_many :attachments, serializer: AttachmentSerializer
end
