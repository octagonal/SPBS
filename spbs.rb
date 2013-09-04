require 'json'
require_relative 'spbs/fetch.rb'
require_relative 'spbs/query.rb'

query = SPBS::Query.new(
  :query => "The Newsroom 2012 S02E07 720p HDTV x264 EVOLVE"
)

request = SPBS::Fetch.new(query.queryset)
request.resultset.each {|test| puts test.url}
