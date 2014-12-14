#!/usr/bin/env ruby
require 'pp'
require 'json'
require 'csv'
require 'pry'

data = JSON.load File.open "combined.json"

data.each_value do |v|
  # pp v 
  # puts "#{v['Speed']['Ground']}  #{v['Speed']['Water']}  #{v['Speed']['Air']}  #{v['Speed']['Anti-Gravity']}"
  # puts (v['Speed']['Ground'] + v['Speed']['Air'] + v['Speed']['Water'] + v['Speed']['Anti-Gravity']) / 4.0
  v['SpeedByTerrain'] = v['Speed']
  v['HandlingByTerrain'] = v['Handling']
  v['Speed'] = (v['Speed']['Ground'] + v['Speed']['Air'] + v['Speed']['Water'] + v['Speed']['Anti-Gravity']) / 4.0
  v['Handling'] = (v['Handling']['Ground'] + v['Handling']['Air'] + v['Handling']['Water'] + v['Handling']['Anti-Gravity']) / 4.0
  v['OptionsString'] = v['Options'].flatten
  v
end

File.open("averaged_and_combined.json","w") { |f| f.write JSON.generate data }
# pp cs.first[1] + vs.first[1] + ws.first[1]
