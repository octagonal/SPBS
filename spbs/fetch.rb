require 'nokogiri'
require 'open-uri'
require_relative 'result.rb'

module SPBS

  class Fetch
    include Enumerable
    BASE_URL = "http://thepiratebay.sx/search/"
    attr_reader :request, :amount, :resultset

    def initialize(args)
      @resultset = Array.new
      pop_resultset(args)
      @amount    = 5
    end

    def each
      resultset.each {|result| yield(result)}
    end

    def pop_resultset(queries)
     queries.each do |query|
       @resultset << Result.new(query)
     end
    end

    def fetch_results
      @resultset.each do |request|

        doc = Nokogiri::HTML(open(request.url))
        torrents = doc.css("#searchResult > tr")

        request.add_node(@amount) do |node,n|
          torrent               = torrents[n]
          node.name             = torrent.css("td")[1].css("div.detName a")[0].inner_text
          node.magnet           = torrent.css("td")[1].css("a")[1].attr("href")
          node.uploader["name"] = torrent.css("td")[1].css("font > a.detDesc").inner_text
          node.date             = torrent.css("td")[1].css("font").inner_text.split(",")[0].split(/ /)[1]
          node.size             = torrent.css("td")[1].css("font").inner_text.split(",")[1].split(/ /).reject!{|b| b == ""}[1]
          node.category["main"] = torrent.css("td")[0].css("a")[0].inner_text
          node.category["sub"]  = torrent.css("td")[0].css("a")[1].inner_text
          node.peers["leeches"] = torrent.css("td")[3].inner_text.to_i
          node.peers["seeds"]   = torrent.css("td")[2].inner_text.to_i
        end
      end
    end
  end
end
