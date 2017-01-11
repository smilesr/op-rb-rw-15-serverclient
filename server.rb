require 'socket'
require 'json'

server = TCPServer.open(2000) 

puts "Server listening on port 2000"
loop {
  client = server.accept
  request = ""
  while line = client.gets
    request += line  
    break if request =~ /\r\n\r\n$/
  end
  request_arr = request.split(" ")
  verb = request_arr[0]
  uri = request_arr[1].tr("/","")
  puts "#{verb} request received . . ."
  if File.file?(uri)
    if verb == "GET"
      status_code = "200"
      status_message = "OK"
      bytes_number = 0
      content = ''
      f= File.open(uri, "r")
         content= f.read
         bytes_number = content.bytesize
      f.close
      client.puts "HTTP/1.1 " + "#{status_code} " + "#{status_message} "
      client.puts "Date: " + "#{Time.now.ctime} "
      client.puts "Content-Type: text/html "
      client.puts "Content-Length: " + "#{bytes_number}" + "\r\n\r\n"
      client.puts content
      client.close

    elsif verb == "POST"
      body_size = request_arr.last.to_i  
      body = client.read(body_size)
      params = JSON.parse(body)
      template = File.read(uri)
      result = ''
      for i in params.keys
        params[i].each do |k,v|
          result << "<li> #{k} : #{v} </li>"
          end
      end
      final_html = template.gsub!("<%= yield %>",result)  
      client.print "HTTP/1.0 200 OK\r\n"
      client.print "\r\n"
      client.print final_html
      client.close
    end
  else
    status_code = "400"
    status_message = "File Not Found"
    client.puts "Status Code: #{status_code} - #{status_message}"
    client.close 
  end
}
