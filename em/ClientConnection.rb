require 'json'
require 'Client.rb'

class ClientConnection

	attr_reader	:socket
			:channel
			:id
			:client

	def initialize(socket, channel)
	
		@socket = socket

		socket.onopen { 
			@client = Client.new		
			socket.send @client.to_json
			subscribe(channel)
		}

	end

	def subscribe(channel)
		@channel = channel
		@id = channel.subscribe {|message| @socket.send(message) }
		@socket.onmessage {|message| handleMessage(message) }
		@socket.onclose { unsubscribe }
	end
	def unsubscribe()
		broadcast %({"type":"ejected","id":#{@client.id}})    
		@channel.unsubscribe(@id)
	end

	def broadcast(message)
		@channel.push message
	end

	def handleMessage(data)

		json = JSON.parse(data) rescue {};

		case json['type']
		when 'init'
			broadcast %({"type":"init","id":#{@client.id},"name":#{@client.name}})	
		when 'message'
			broadcast %({"type":"message","id":#{@client.id},"message":"#{json['message']}"})
		when 'namechange'
			@client.name = json['name']
			broadcast %({"type":"namechange","id":#{@client.id},"name":"#{@client.name}"})
		when 'sync'
			@client.x = json['x']
			@client.y = json['y']
			broadcast %({"type":"sync","id":#{@client.id},"name":"#{@client.name}","x":#{@client.x},"y":#{@client.y}})
		end
		
	end
	
end
