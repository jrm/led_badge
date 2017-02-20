require "sinatra/base"
require "rack/contrib"
require "haml"
require "json"

class Server < Sinatra::Base

  use Rack::PostBodyContentTypeParser

  def self.run(opts = {})
    set :root, File.dirname(__FILE__)
    set :bind, opts[:bind] || '0.0.0.0'
    set :port, opts[:port] || '9292'
    set :debug, opts[:debug]
    run!
  end

  helpers do

    def characters
      [
        {character: ":STAR:", icon: "fa-star"},
        {character: ":HEART:", icon: "fa-heart"},
        {character: ":LEFT:", icon: "fa-arrow-left"},
        {character: ":RIGHT:", icon: "fa-arrow-right"},
        {character: ":PHONE2:", icon: "fa-phone"},
        {character: ":SMILE:", icon: "fa-smile-o"},
        {character: ":CIRCLE:", icon: "fa-circle"},
        {character: ":TAIJI:", icon: "fa-sun-o"},
        {character: ":MUSIC:", icon: "fa-music"},
      ]
    end

  end

  get '/' do
    haml :index
  end

  post '/' do
    puts params.inspect
    badge = LedBadge::Badge.new(params[:device_options])
    if params[:messages]
      badge.set_messages params[:messages]
    else
      badge.set_message "#{params[:message]}"
    end
  end

  post '/reset' do
    badge = LedBadge::Badge.new
    badge.set_messages 6.times.map {|i| {message: " ", options: {speed: 1, action: "SCROLL"}} }
  end

end
