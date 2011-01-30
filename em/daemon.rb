#!/usr/bin/ruby

$: << File.dirname(__FILE__)

require 'rubygems'
require 'syslog'
require 'em-websocket'
require 'ClientConnection.rb'

Syslog.open('WebSocketTest')

begin
	EventMachine.run do

		channel = EM::Channel.new

		EventMachine::WebSocket.start(:host => '0.0.0.0', :port => 8080, :debug => true) do |socket|
			
			ClientConnection.new(socket,channel)
		
		end
	end
end
