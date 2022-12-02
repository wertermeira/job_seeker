# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    user_role { %w[admin job_seeker employer].sample }
  end
end
