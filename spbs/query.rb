require 'json'
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
      YAML.load_file("../config.yml")
    end
  end
end
