FactoryBot.define do
  factory :project do
    name { Faker::Company.name }
    short_description { Faker::Company.catch_phrase }
    long_description { Faker::Marketing.buzzwords }
    target_amount { rand(30_000...3_000_000).round(-4) }
    association :category
    thumbnail_data { ImageUploader.new(:store).upload(File.new(Rails.root.join('app/assets/images/seed/LITA_thumbnail.png'))).to_json }
    landscape_data { ImageUploader.new(:store).upload(File.new(Rails.root.join('app/assets/images/seed/LITA_landscape.jpg'))).to_json }
  end
end
