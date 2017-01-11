require 'socket'    
require 'json'

puts "Welcome to SmilesBrowser"
host = 'localhost'
port = 2000 
path = "/index.html"
request = "GET #{path} HTTP/1.1\r\n\r\n"
s = TCPSocket.open(host,port)  

puts "Do you want to send a GET or POST request?"
answer = gets.chomp.upcase

if answer == "GET"
  s.puts(request)               
  response = s.read  
  headers,body = response.split("\r\n\r\n", 2) 
  puts "HEADERS:"
  puts headers
  puts "BODY:"
  puts body

elsif answer == "POST"
  puts "Ok. Let's register a Viking."
  puts "What is Viking's name?"
  name = gets.chomp
  puts "What is Viking's email address"
  email = gets.chomp
  data = {}
  data[:viking] = {}
  data[:viking][:name] = name
  data[:viking][:email] = email
  content = data.to_json
  path = '/thanks.html'
  message = "POST #{path} HTTP/1.1\r\n" + "From: abc@abc.com\r\n" +
                 "User-Agent: SmilesBrowser\r\nContent-Type:  application/json\r\n" +
                 "Content-Length: #{content.length}\r\n\r\n" +
                 "#{content}\r\n"
  s.puts(message)
  puts ""
  puts "sent POST request:"
  puts "#{message}"
  puts""
  response = s.read
  print response
end
s.close

