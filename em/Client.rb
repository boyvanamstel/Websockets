class Client 

	@@count = 0

	attr_reader	:id

	attr_accessor	:name,
			:x,
			:y,
			:mouseState

	def initialize()
		@id = @@count += 1
		@name = %(Visitor#{@id})
		@x = 0
		@y = 0
		@mouseState = %(false)
	end
	
	def to_json
		%({"type":"client","id":"#{@id}","name":"#{@name}","x":#{@x},"y":#{@y}})
	end

end
