require "mangopay"

MangoPay.configure do |c|
  c.preproduction = true
  c.client_id = 'test-capsens'
  c.client_apiKey = 'YOEa3orzMhcqNjxWN41aU9BPA5Jqhqr4ZmnfkQmq33DBkqGpHg'
  c.log_file = File.join('log', 'mangopay.log')
  c.http_timeout = 10_000
end
