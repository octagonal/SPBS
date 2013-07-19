#!/Users/anthony/.rvm/rubies/ruby-2.0.0-p0/bin/ruby

require 'nokogiri'
require 'open-uri'

def fetch_magnet(url)
  url.gsub!(" ", "%20")
  #puts "URL: #{url}"

  doc = Nokogiri::HTML(open("http://thepiratebay.sx/search/" + url + "/0/7/0"))

  magnet = ""
  title = ""
  size = ""

  torrent = doc.css("#searchResult > tr")

  torrent.each do |t|

    #puts "[#{t.css("td")[0].css("center a")[1].content}]\t#{t.css("td")[1].css("div.detName a").first.content}"
    #puts "#{t.css("td")[2].inner_text}"
    #(t.css("td")[2].inner_text.to_i/269).times {print "#"}
    #puts "#{t.css("td")[1].css("> a")[0]["href"]}"

    #puts t.css("td")[2].css(".detname a")["href"]

    #puts "\n"

=begin
    t.css("td").each do |td|

      td

      if a["href"].to_s.start_with?("/torrent/")
        #puts title
        title = a.inner_text
      end

      if a["href"].to_s.start_with?("magnet")
        magnet = a["href"]
        #puts magnet
        puts "\n"
      end

    end
=end

  end

  torrent.length.times do |current|
    puts "(#{current}):\t[#{torrent[current].css("td")[1].css("div.detName a").first.content}]?" #Naam
    puts "\t#{torrent[current].css("td")[2].inner_text} Seeders\n\t#{torrent[current].css("td")[0].css("center a")[1].content}\n\n" #seeders en categorie
    puts "#{torrent[current].css("td")[1].css("> a")[0]["href"]}" #magnet link
    puts "Downloaden? (y,n,q)"
    answer = gets.chomp
    if    answer == "y" or answer == "yes"
      command = torrent[current].css('td')[1].css('> a')[0]['href']
      command = "open '#{command}'"
      exec command
    elsif answer == "n" or answer == "no"
      next
    elsif answer == "q" or answer == "quit"
      break
    else
      next
    end
  end

end

puts "Wat wil je downloaden?"
fetch_magnet(gets.chomp)