FactoryBot.define do
  factory :project do
    name { Faker::Company.name }
    short_description { Faker::Company.catch_phrase }
    long_description { Faker::Marketing.buzzwords }
    email { Faker::Internet.email }
    owner_first_name { Faker::Name.first_name }
    owner_last_name { Faker::Name.last_name }
    owner_birthdate { Faker::Date.in_date_period }
    target_amount { rand(30_000...3_000_000).round(-4) }
    mangopay_id { '123' }
    wallet_id { '456' }
    association :category
    thumbnail_data { ImageUploader.new(:store).upload(File.new(Rails.root.join('app/assets/images/seed/LITA_thumbnail.png'))).to_json }
    landscape_data { ImageUploader.new(:store).upload(File.new(Rails.root.join('app/assets/images/seed/LITA_landscape.jpg'))).to_json }

    factory :project_with_counterparts do
      after(:create) do |project|
        project.counterparts << create(:counterpart, project: project)
      end
    end
  end
end
