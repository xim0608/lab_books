require 'net/http'
require 'json'
require 'uri'

module OpenBd
  class Api
    def initialize(isbn)
      # params = URI.encode_www_form({q: "isbn:#{isbn}"})
      @base_uri = "https://api.openbd.jp/v1/get?isbn=#{isbn}"
      # puts @base_uri
    end

    def get_json
      uri = URI.parse(@base_uri)
      json = Net::HTTP.get(uri)
      result = JSON.parse(json, {:symbolize_names => true})
    end

    def get_description
      json = get_json
      outline = ""
      description = ""
      # puts json
      if json[0].present?

        desc_and_table = json[0].dig(:onix, :CollateralDetail)
        # p desc_and_table
        if desc_and_table.empty?
          p "empty"
        else
          if desc_and_table.dig(:TextContent).present?
            desc_and_table.dig(:TextContent).each do |text|
              if text[:Text].present?
                if text[:TextType] == "04"
                  outline = text[:Text]
                elsif text[:TextType] == "03"
                  description = text[:Text]
                end
              end
            end
          else
            p "empty"
          end
        end
      end

      {outline: outline, description: description}
    end

    def get_booklog_missing
      # booklogのapiから取得した本には、isbn_13, publisher, author, publish_year, pagesが欠けている
      json = get_json
      isbn_13 = nil
      publisher = nil
      author = nil
      publisher_year = nil
      # puts json
      if json[0].present?

        sequence_authors = json[0].dig(:onix, :DescriptiveDetail, :Contributor)
        sequence_authors.each do |sequence_author|
          author = sequence_author.dig(:PersonName, :content) if sequence_author[:SequenceNumber] == "1"
        end
        publisher = json[0].dig(:summary, :publisher)
        isbn_13 = json[0].dig(:summary, :isbn)
        publish_year = json[0].dig(:summary, :pubdate).slice(0, 4)
      end

      {isbn_13: isbn_13, publisher: publisher, author: author, publish_year: publish_year}
    end

  end
end