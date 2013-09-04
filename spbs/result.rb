require_relative 'fetch.rb'

module SPBS
  class Result
    attr_accessor :name, :url
    attr_accessor :magnet, :uploader, :date, :size, :category, :peers
    def initialize(name)
      @name = name
      @url  = form_url(@name)

      @category = Hash.new
      @peers = Hash.new
    end

    def form_url(name)
        url = name.dup
        @url = Fetch::BASE_URL + clean_url(name) + "/0/7/0"
    end

    def clean_url(dirty_url)
      dirty_url.gsub(" ", "%20")
    end
  end
end
