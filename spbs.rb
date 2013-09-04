require 'nokogiri'
require 'open-uri'
require 'json'
require 'pp'
require 'yaml'

module SPBS

  class Query
    attr_reader :category, :queryset, :sort, :download_dir
    def initialize(args)
      args = default.merge(args)
      @category     = args[:category]
      @sort         = args[:sort]
      @download_dir = Dir.new(args[:download_dir])
      @queryset     = Array.new
      detect_set(args[:query])
    end

    def detect_set(query)
      detection = query.scan(/(%(\d+),(\d+)%)/).reverse
      if !detection.empty?
        form_query(detection.size-1,detection,query)
      else
        @queryset << query
      end
    end

    def form_query(iteration,match,string)
      matchdata  = match[iteration][0]
      matchbegin = match[iteration][1]
      matchend   = match[iteration][2]

      (matchbegin..matchend).each do |n|
        parsed = ''
        parsed = string.sub(matchdata, n.rjust(2,"0"))
        if iteration != 0
          form_query(iteration-1,match,parsed)
        else
          @queryset << parsed
        end
      end
    end

    def default
      YAML.load_file("config.yml")
    end
  end

  class Fetch
    def initialize(args)
      @request = request
    end

    def clean_url(dirty_url)
      url.gsub(" ", "%20")
    end

    def form_url(query)
      url = query.dup
      url.gsub!(" ", "%20")

      doc = Nokogiri::HTML(open("http://thepiratebay.sx/search/" + url + "/0/7/0"))
      torrents = doc.css("#searchResult > tr")

      results = Array.new(torrents.length) { Hash.new }

      #Here's to hoping nobody will ever read this disastercode
      torrents.length.times do |current| result = results[current]
        torrent = torrents[current]
        result["name"] = torrent.css("td")[1].css("div.detName a")[0].inner_text
        result["magnet"] = torrent.css("td")[1].css("a")[1].attr("href")
        result["uploader"] = Hash.new
          result["uploader"]["name"] = torrent.css("td")[1].css("font > a.detDesc").inner_text
          puts torrent.css("td")[1].css("img").attr("alt")[1].inner_text
          #if torrent.css("td")[1].css("a")[2].css("img").attr("alt").inner_text == "VIP"
          #  result["uploader"]["trusted"] == true
          #else
          #  result["uploader"]["trusted"] == false
          #end
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
    end
  end

end

query = SPBS::Query.new(
  :query => "Oreimo S01 E30"
)

puts query.queryset
puts query.category
puts query.sort
puts query.download_dir
