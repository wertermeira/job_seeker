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

    it { is_expected.to define_enum_for(:role).with_values(%i[admin job_seeker employer]).with_prefix(:role) }

    context 'when custom validate' do
      let(:attachments_attributes) do
        {
          file_path: 'http://site.com/image.jpg',
          title: Faker::Name.name,
          kind: kind
        }
      end
      let(:user) do
        {
          name: Faker::Name.name,
          email: email,
          role: role,
          attachments_attributes: Array.new(attach_times) { attachments_attributes }
        }
      end

      context 'when valid' do
        let(:email) { '' }
        let(:role) { 'job_seeker' }
        let(:kind) { 'resume' }
        let(:attach_times) { 1 }

        it do
          expect(described_class.new(user)).to be_valid
        end
      end

      context 'when valid with email' do
        let(:email) { Faker::Internet.email }
        let(:role) { 'job_seeker' }
        let(:kind) { 'resume' }
        let(:attach_times) { rand(2..5) }

        it do
          expect(described_class.new(user)).to be_valid
        end
      end

      context 'when is invalid' do
        let(:email) { '' }
        let(:role) { 'job_seeker' }
        let(:kind) { 'resume' }
        let(:attach_times) { rand(2..10) }

        it do
          to_validate = described_class.new(user)
          to_validate.valid?
          expect(to_validate.errors[:attachments_attributes]).to include('to add more resumes. email is required')
        end
      end
    end
  end

  describe '.associations' do
    it { is_expected.to have_many(:attachments).dependent(:destroy) }
  end
end
