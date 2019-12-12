after :categories do
  puts "Creating 1 Project..."
  category = Category.find_by(name: "Startup for good")
  Project.find_or_create_by(
    name: "1083",
    short_description: Faker::Company.catch_phrase,
    long_description: Faker::Marketing.buzzwords,
    target_amount: 30_000,
    category: category
  )
  puts "... Creation completed."
end
