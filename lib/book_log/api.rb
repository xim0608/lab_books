require 'net/http'
require 'json'
require 'uri'

module BookLog
  class Api
    def initialize(count=5)
      # params = URI.encode_www_form({q: "isbn:#{isbn}"})
      @base_uri = "http://api.booklog.jp/json/#{ENV['BOOKLOG_ID']}?count=#{count}"
      puts @base_uri
    end

    def get_data
      uri = URI.parse(@base_uri)
      json = Net::HTTP.get(uri)
      result = JSON.parse(json, {:symbolize_names => true})
      books = result[:books]
    end
  end
end
