require_relative 'fetch.rb'

module SPBS
  class Result
    attr_accessor :name, :url, :nodeset
    def initialize(name)
      @name    = name
      @url     = form_url(@name)
      @nodeset = Array.new
    end

    def form_url(name)
      url  = name.dup
      @url = Fetch::BASE_URL + clean_url(name) + "/0/7/0"
    end

    def clean_url(dirty_url)
      dirty_url.gsub(" ", "%20")
    end

    def add_node(times)
      times.times do |n|
        @nodeset << ResultNode.new
        yield(@nodeset.last, n)
      end
    end
  end

  class ResultNode
    attr_accessor :magnet, :name, :uploader, :date, :size, :category, :peers
    def initialize
      @category = Hash.new
      @uploader = Hash.new
      @peers    = Hash.new
    end
  end
end
