require 'serialport'
require 'json'
require 'logger'

module LedBadge
  class Badge

    SERIAL_DEVICE = File.exist?('/dev/tty.usbserial') ? '/dev/tty.usbserial' : '/dev/ttyUSB0'
    SERIAL_PARAMS = {"stop_bits" => 1, "parity" => SerialPort::NONE, "baud" => 38400}

    def initialize(opts = {})
      device_name = opts[:device_name] || SERIAL_DEVICE
      serial_params = opts[:serial_params] || SERIAL_PARAMS
      log_file = opts[:log_file]
      debug = opts[:debug]
      @port = SerialPort.new(device_name, serial_params)
      @logger = Logger.new(log_file || $stdout)
      @logger.level = debug ? Logger::DEBUG : Logger::INFO
    end

    def set_message(message, opts = {})
			payload = build_payload(message, opts)
  		packets = build_packets(0x06, payload)
  		send_packets(packets)
    end

    def set_messages(message_array = [])
  		index = 1
  		address = 0x06
      num_messages = message_array.length
  		packets = message_array.inject([]) do |acc,msg|
        msg = JSON.parse(JSON[msg], symbolize_names: true)
        if msg[:message] && msg[:message].length > 0
    			message = msg[:message]
    			opts = msg[:options] || {}
    			opts.merge!({msgindex: index})
    			payload = build_payload(message, opts)
    			acc += build_packets(address, payload)
    			address += 1
          acc
        else
          acc
        end
  		end
      @logger.debug message_array.inspect
      @logger.debug packets.inspect
  		send_packets(packets, num_messages)
    end

    private

    def build_payload(message, opts)
  		options = {
  	     speed: 5,
  	     msgindex: 1,
  	     action: "LedBadge::LedActions::SCROLL"
  	  }.merge(opts)
      puts options.inspect
      action = options[:action].is_a?(String) ? Object.const_get("LedBadge::LedActions::#{options[:action]}") : options[:action]
  		msgFile = [options[:speed].to_s, options[:msgindex].to_s, action, message.length].pack("aaac").bytes.to_a
  		msgFile += replace_special_charaters(message).bytes.to_a
  		ml = msgFile.length
  		pl = Packet::BYTES_PER_PACKET
  		dif = (pl * (((ml - 1) / pl) + 1) ) - ml
  		msgFile += [0x00]*dif unless dif <= 0
  		msgFile
    end

    def build_packets(address1,payload)
  		packets = Array.new
  		address2 = 0x00
  		payload.each_slice(64) do |part|
  			packets << LedBadge::Packet.new(address1, address2, part)
  			address2 += 0x40
  		end
  		packets
    end

    def send_packets(packets, num_messages=1)
  		initial = [0x00]
  		send_data(initial)
  		packets.each do |p|
  			send_data(p.format)
  		end
  		mapping = {
  			1 => 0x01,
  			2 => 0x03,
  			3 => 0x07,
  			4 => 0x0f,
  			5 => 0x1f,
  			6 => 0x3f,
  			7 => 0x7f,
  			8 => 0xff
  		}
  		last_byte = mapping[num_messages]
  		send_data([0x02,0x33,last_byte])
    end

    def replace_special_charaters(message)
      map = LedBadge::SpecialCharacters::LIST.inject({}) {|acc,i| acc.merge!({":#{i}:" => Object.const_get("LedBadge::SpecialCharacters::#{i}")})}
      message.gsub(/:(#{LedBadge::SpecialCharacters::LIST.join('|')}):/, map)
    end

    def send_data(data)
  		@port.write data.pack('C*')
    end

  end
end
