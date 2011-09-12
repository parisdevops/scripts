#!/usr/bin/env ruby

# retrieve meetups attendees from lanyrd
# and print some stats

require 'rubygems'
require 'nokogiri'
require 'open-uri'

urls = []
urls << "http://lanyrd.com/2010/first-devops-meetup-paris/attendees/?page="
2.upto(6) do |i|
  urls << "http://lanyrd.com/2011/paris-devops-meetup-#{i}/attendees/?page="
end

meetups = []
urls.each do |url|
  attendees = []
  page = 1
  begin
    doc = Nokogiri::HTML(open(url + page.to_s)) rescue nil
    page+=1
    attendees << doc.css('div.mini-profile span.name a[href]').map{|e| e['href'].gsub(/\/profile\/(.*)\//,'\1')} unless doc.nil?
  end while not doc.nil?
  meetups << attendees.flatten
end

people = {}
meetups.each{|m| m.each{|p| people[p].nil? ? people[p]=1 : people[p]+=1}}
people_by_participations = people.inject([]){|m,p| m[p[1]].nil? ? m[p[1]]=[p[0]] : m[p[1]]<<p[0] ; m}

puts "parisdevops meetups stats :"
puts "#{meetups.count} meetups"
puts "#{meetups.flatten.count} participations"
puts "#{people.count} participants"
puts "stats by number of participations :"
people_by_participations.each_with_index{|e,i| puts "#{i} participations : #{e.count rescue 0} people - #{(e.count rescue 0)*100/(people.count)}% (#{e.join(',') rescue ''})"}

