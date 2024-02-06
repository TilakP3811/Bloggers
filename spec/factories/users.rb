# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              { 'Pa$$word1!' }
    password_confirmation { 'Pa$$word1!' }
    verified              { true }
  end

  trait :incomplete_verification do
    verified { false }
  end
end
