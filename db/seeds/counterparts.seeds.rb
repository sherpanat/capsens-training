after :projects do
  puts "Creating 2 Counterparts for 1 Project..."
  project = Project.find_by(name: "1083")
  Counterpart.find_or_create_by(
    description: Faker::Company.catch_phrase,
    threshold: project.target_amount / 1000,
    stock: 10,
    project: project
  )
  puts "... 1 created..."
  Counterpart.find_or_create_by(
    description: Faker::Company.catch_phrase,
    threshold: project.target_amount / 500,
    stock: 3,
    project: project
  )
  puts "... Creation completed."
end
