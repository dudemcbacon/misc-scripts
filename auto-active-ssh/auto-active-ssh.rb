#!/usr/bin/env ruby

require 'net/ssh'
require 'highline/import'
require 'pry'

username = ask('Username:  ') { |q| q.echo = true }
password = ask('Password:  ') { |q| q.echo = '*' }

list = IO.readlines('hosts-list')

list.each_with_index do |line, index|

  unless index == 0 
    hostname = line.split('   ')[1]
    
    print("Logging into #{hostname}... ")

    begin
      Net::SSH.start(hostname, username, :password => password) do |ssh|
        ssh.exec!("hostname")
      end
      puts("Success.")
    rescue Net::SSH::AuthenticationFailed
      puts("Authentication failure.")
    rescue SocketError
      puts("Could not resolve.")
    rescue
      puts("Unknown failure.") 
    end
  end

end
