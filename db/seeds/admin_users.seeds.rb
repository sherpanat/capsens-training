puts "Creating 1 User Admin..."
AdminUser.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
puts "... Creation completed."
