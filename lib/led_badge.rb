require "led_badge/version"
require "led_badge/feed"
require "led_badge/packet"
require "led_badge/badge"
require "led_badge/server"

module LedBadge

  module LedActions
  	HOLD 	  = 'A'
  	SCROLL 	= 'B'
  	SNOW 	  = 'C'
  	FLASH	  = 'D'
  	HOLDFRAME = 'E'
  end

  module Fonts
  	NORMAL = "\xff\x80"
  	BOLD   = "\xff\x81"
  end

  module SpecialCharacters
    STAR 	   = "\xc0\x02"
    HEART 	 = "\xc0\x04"
    LEFT 	   = "\xc0\x06"
    RIGHT 	 = "\xc0\x08"
    PHONE1 	 = "\xc0\x0a"
    PHONE2 	 = "\xc0\x0c"
    SMILE 	 = "\xc0\x0e"
    CIRCLE   = "\xc0\x10"
    TAIJI 	 = "\xc0\x12"
    MUSIC 	 = "\xc0\x14"
    QUESTION = "\xc0\x16"
    BOX      = "\xc0\x18"
    LIST     = %w(STAR HEART LEFT RIGHT PHONE1 PHONE2 SMILE CIRCLE TAIJI MUSIC QUESTION BOX)
  end

  def self.run_server(opts = {})
    Server.run(opts)
  end

end
