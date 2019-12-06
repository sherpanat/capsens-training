after :users, :projects, :counterparts do
  puts "Creating 1 Contribution by each 2 Users to 1 project..."
  project = Project.find_by(name: "1001pact")
  user = User.find_by(email: "nathan.huberty@lita.co")
  Contribution.find_or_create_by(
    project: project,
    user: user,
    amount: project.target_amount / 20
  )
  puts "... 1 created..."
  user = User.find_by(email: "abel.ilito@lita.co")
  Contribution.find_or_create_by(
    project: project,
    user: user,
    amount: project.target_amount / 5
  )
  puts "... Creation completed."
end
