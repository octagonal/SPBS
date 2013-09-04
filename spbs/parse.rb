string = ARGV[0]
puts string
arr = string.scan(/(%(\d+),(\d+)%)/).reverse
p arr

def form_query(iteration,match,string)
  (match[iteration][1]..match[iteration][2]).each do |n|
    parsed = ''
    parsed = string.sub(match[iteration][0], n.rjust(2,"0"))
    if iteration != 0
      form_query(iteration-1,match,parsed)
    else
      puts parsed
    end
  end
end

if !arr.empty?
  puts true
  form_query(arr.size-1,arr,string)
end

#query = Query.new(ARGV[0])
#query.search
=begin
class Query
  attr_accessor category, init_sort, set

  def initialize
    detect_set
  end

  def detect_set
    if set_detected
      form_query
    end
  end

  def each
    self.set.each do |part|
      yield(n)
    end
  end

  def search
      self.each { |part| find_torrent(part)}
  end
end
=end
