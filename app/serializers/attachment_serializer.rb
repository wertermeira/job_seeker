# frozen_string_literal: true

class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :title, :kind, :file_path
end
