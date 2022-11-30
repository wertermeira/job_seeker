# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Attachment, type: :model do
  describe 'when db schema' do
    let(:model) { described_class.column_names }

    %w[user_id title file_path kind].each do |column|
      it { expect(model).to include(column) }
    end
  end

  describe '.validates' do
    it { is_expected.to allow_value(Faker::LoremFlickr.image).for(:file_path) }
    it { is_expected.not_to allow_value('file://email.com').for(:file_path) }

    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(150) }

    it { is_expected.to define_enum_for(:kind).with_values(%i[resume cover_letter photo]) }
  end

  describe '.associations' do
    it { is_expected.to belong_to(:user) }
  end
end
