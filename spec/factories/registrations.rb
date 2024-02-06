# frozen_string_literal: true

FactoryBot.define do
  factory :registration do
    user
    uuid { SecureRandom.uuid }
    activation_code { SecureRandom.alphanumeric(6) }
  end
end
