after :projects do
  puts "Creating 2 Counterparts for 1 Project..."
  project = Project.find_by(name: "1001pact")
  Counterpart.find_or_create_by(
    level: 1,
    description: Faker::Company.catch_phrase,
    threshold: project.target_amount / 10,
    stock: 10,
    project: project
  )
  puts "... 1 created..."
  Counterpart.find_or_create_by(
    level: 2,
    description: Faker::Company.catch_phrase,
    threshold: project.target_amount / 5,
    stock: 3,
    project: project
  )
  puts "... Creation completed."
end
