FactoryBot.define do
  factory :user do
    email { 'sangoku@dbz.fr' }
    password { 'azerty' }
    first_name { 'Goku' }
    last_name { 'San' }
    birthdate { '08/07/1988' }
  end

  factory :random_user, class: User do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    birthdate { Faker::Date.in_date_period }
  end
end
