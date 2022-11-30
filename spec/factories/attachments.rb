# frozen_string_literal: true

FactoryBot.define do
  factory :attachment do
    user { create(:user) }
    file_path { Faker::LoremFlickr.image }
    title { Faker::Book.title }
    kind { %w[resume cover_letter photo].sample }
  end
end
