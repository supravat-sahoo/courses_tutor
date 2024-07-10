# encoding: UTF-8
# frozen_string_literal: true

FactoryBot.define do
  factory :tutor do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    course { create(:course) }
  end
end