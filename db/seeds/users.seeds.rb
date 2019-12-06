puts "Creating 2 User..."
User.create(
  email: "nathan.huberty@lita.co",
  password: "12345678",
  first_name: "Nathan",
  last_name: "Huberty",
  birthdate: "08/07/1990"
)
puts "... 1 creation completed..."
User.create(
  email: "abel.ilito@lita.co",
  password: "12345678",
  first_name: "Abel",
  last_name: "Ilito",
  birthdate: "04/12/1922"
)
puts "... Creation completed."
