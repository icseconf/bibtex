require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'date'
require 'set'

# Download bib entries of all ICSE conferences

url = "http://dl.acm.org/event_series.cfm?id=RE228"
doc = Nokogiri::HTML(open(url))
all = doc.search('a[title^="ICSE"]').collect{|m|[m['title'],m['href'][/id=(\d+)/,1]]}
all.each do |title,id|
  year = title[/\d+/].to_i
  year += 2000 if year <= 12
  year += 1900 if year <= 99
  p fname = "icse#{year}.bib"
  url = "http://dl.acm.org/tab_about.cfm?id=#{id}&type=proceeding&parent_id=#{id}&parent_type=proceeding"
  doc = Nokogiri::HTML(open(url))
  ids = doc.search('a[href^="citation.cfm"]').collect{|m|m['href'][/id=(\d+)/,1]}
  done = File.read(fname).grep(/acmid/).collect{|m|m[/\d+/]}.to_set
  ids.each do |each|
    p each
    next if done.include?(each)
    p url = "http://dl.acm.org/exportformats.cfm?id=#{each}&expformat=bibtex"
    sleep(10*rand)
    bibtex = Nokogiri::HTML(open(url)).at('pre').content
    next unless bibtex[/acmid/]
    File.open(fname,'a'){|f|f.puts(bibtex)}
  end  
end

__END__
