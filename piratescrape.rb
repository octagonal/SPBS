#!/Users/anthony/.rvm/rubies/ruby-2.0.0-p0/bin/ruby

require 'nokogiri'
require 'open-uri'
require 'pp'

def fetch_magnet(query)
  url = query.dup
  url.gsub!(" ", "%20")

  doc = Nokogiri::HTML(open("http://thepiratebay.sx/search/" + url + "/0/7/0"))

  magnet = ""
  title = ""
  size = ""

  torrent = doc.css("#searchResult > tr")

  results = Hash.new

  torrent.length.times do |current|
    puts current
    #puts "(#{current}):\t[#{torrent[current].css("td")[1].css("div.detName a").first.content}]?" #Naam
    #puts "\t#{torrent[current].css("td")[2].inner_text} Seeders\n\t#{torrent[current].css("td")[0].css("center a")[1].content}\n\n" #seeders en categorie
    #puts "#{torrent[current].css("td")[1].css("> a")[0]["href"]}" #magnet link
    #puts "Downloaden? (y,n,q)"
    #answer = gets.chomp
    #command = torrent[current].css('td')[1].css('> a')[0]['href']
  end

end

#puts "Wat wil je downloaden?"
fetch_magnet(ARGV[0])
