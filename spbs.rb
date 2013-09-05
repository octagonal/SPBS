require 'json'
require_relative 'spbs/fetch.rb'
require_relative 'spbs/query.rb'

query = SPBS::Query.new(
  :query => "The Newsroom 2012 S02E07 720p HDTV x264 EVOLVE"
)

request = SPBS::Fetch.new(query.queryset)
request.fetch_results

request.each do |result|
  result.each do |node|
  end
end

request.each_result

request.each_node
