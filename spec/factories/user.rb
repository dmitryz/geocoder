FactoryBot.define do
  factory :user do
    name "Andrew Too"
    password 'testtest'
    password_confirmation 'testtest'
    email 'test@test.com'
    provider 'email'
  end
end
