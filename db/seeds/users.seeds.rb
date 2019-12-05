puts "Creating 1 User..."
User.create(
  email: "nathan.huberty@lita.co",
  password: "12345678",
  first_name: "Nathan",
  last_name: "Huberty",
  birthdate: "08/07/1990"
)
puts "... Creation completed."
