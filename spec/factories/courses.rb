# encoding: UTF-8
# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    title { Faker::Lorem.characters(number: 25) }
    description { Faker::Lorem.characters(number: 125) }
  end
end