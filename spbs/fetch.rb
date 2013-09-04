require 'nokogiri'
require 'open-uri'
require_relative 'result.rb'

module SPBS

  class Fetch
    BASE_URL = "http://thepiratebay.sx/search/"
    attr_reader :request, :amount, :resultset

    def initialize(args)
      @resultset = Array.new
      pop_resultset(args)
      @amount    = 5
    end

    def pop_resultset(queries)
     queries.each do |query|
       @resultset << Result.new(query)
     end
    end

    def fetch_results
      @request.each do |req|
        doc = Nokogiri::HTML(open(req))
        torrents = doc.css("#searchResult > tr")
        results = Array.new(@amount) { Hash.new }

        #Here's to hoping nobody will ever read this disastercode
        @amount.times do |current|
          result = results[current]
          torrent = torrents[current]
          result["name"] = torrent.css("td")[1].css("div.detName a")[0].inner_text
          result["magnet"] = torrent.css("td")[1].css("a")[1].attr("href")
          result["uploader"] = Hash.new
          result["uploader"]["name"] = torrent.css("td")[1].css("font > a.detDesc").inner_text
          result["date"] = torrent.css("td")[1].css("font").inner_text.split(",")[0].split(/ /)[1]
          result["size"] = torrent.css("td")[1].css("font").inner_text.split(",")[1].split(/ /).reject!{|b| b ==""}[1]
          result["category"] = Hash.new
          result["category"]["main"] = torrent.css("td")[0].css("a")[0].inner_text
          result["category"]["sub"] = torrent.css("td")[0].css("a")[1].inner_text
          result["peers"] = Hash.new
          result["peers"]["leeches"] = torrent.css("td")[3].inner_text.to_i
          result["peers"]["seeds"] = torrent.css("td")[2].inner_text.to_i
          if result["peers"]["leeches"] == 0
            result["peers"]["ratio"] = result["peers"]["seeds"]
          elsif result["peers"]["seeders"] == 0
            result["peers"]["ratio"] = 0
          else
            result["peers"]["ratio"] = results[current]["peers"]["seeds"]/results[current]["peers"]["leeches"]
          end
        end
        @resultset << results
      end
    end
  end
end
