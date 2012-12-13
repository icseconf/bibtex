require 'rubygems'
require 'nokogiri'
require 'open-uri'

id = 2337223

url = "http://dl.acm.org/tab_about.cfm?id=#{id}&type=proceeding&parent_id=#{id}&parent_type=proceeding"
doc = Nokogiri::HTML(open(url))
ids = doc.search('a[href^="citation.cfm"]').collect{|m|m['href'][/id=(\d+)/,1]}
ids.drop(1).each do |each|
  url = "http://dl.acm.org/exportformats.cfm?id=#{each}&expformat=bibtex"
  puts Nokogiri::HTML(open(url)).at('pre').content
  `sleep 0.1`
end
