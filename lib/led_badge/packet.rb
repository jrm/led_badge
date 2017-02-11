module LedBadge
  class Packet
    
  	BYTES_PER_PACKET = 64

  	attr_accessor :command, :unknown, :address1, :address2, :data

  	def initialize(address1, address2, data)
  		@command = 0x02
  		@uknown = 0x31
  		@address1 = address1
  		@address2 = address2
  		@data = data
  	end

  	def format
  		d = [@command, @uknown, @address1, @address2].pack("cccc").bytes.to_a
  		d += @data
  		checksum = calcChecksum(d[1..d.length])
  		d << checksum
  	end

  	def calcChecksum(data)
  		val = data.inject(0) do |sum,item| 
  			sum + item
  		end
  		val &= 0xff
  	end
    
  end
end
