# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'when db schema' do
    let(:model) { described_class.column_names }

    %w[name email role].each do |column|
      it { expect(model).to include(column) }
    end
  end

  describe '.validates' do
    it { is_expected.to allow_value(Faker::Internet.email).for(:email) }
    it { is_expected.not_to allow_value('email.com').for(:email) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(150) }

    it { is_expected.to define_enum_for(:role).with_values(%i[admin job_seeker employer]) }
  end

  describe '.associations' do
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
  end
end
