require 'net/http'
require 'json'
require 'uri'

module OpenBd
  class Api
    def initialize(isbn)
      # params = URI.encode_www_form({q: "isbn:#{isbn}"})
      @base_uri = "https://api.openbd.jp/v1/get?isbn=#{isbn}"
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
      return '' if json[0].nil?

      desc_and_table = json[0].dig(:onix, :CollateralDetail)
      p desc_and_table
      if desc_and_table.empty?
        p "empty"
      else
        p desc_and_table.dig(:TextContent)
      end
      # p desc_and_table
      # puts desc
      # description = desc || ""
    end

  end
end