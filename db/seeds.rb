# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Creating 1 User Admin + 1 User..."
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
User.create!(
  email: "nathan.huberty@lita.co",
  password: "12345678",
  first_name: "Nathan",
  last_name: "Huberty",
  birthdate: "08/07/1990"
)
puts "... Creation completed."
