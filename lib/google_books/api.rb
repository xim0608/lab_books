require 'net/http'
require 'json'
require 'uri'

module GoogleBooks
  class Api
    def initialize(isbn)
      # params = URI.encode_www_form({q: "isbn:#{isbn}"})
      @base_uri = "https://www.googleapis.com/books/v1/volumes?q=isbn:#{isbn}&key=#{ENV["GOOGLE_BOOKS_API_KEY"]}"
      puts @base_uri
    end

    def get_json
      uri = URI.parse(@base_uri)
      json = Net::HTTP.get(uri)
      result = JSON.parse(json, {:symbolize_names => true})
    end

    def get_description
      json = get_json
      puts json
      desc = json.dig(:items, 0, :volumeInfo, :description)
      puts desc
      description = desc || ""
    end

  end
end