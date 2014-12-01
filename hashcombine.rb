#!/usr/bin/env ruby
require 'pp'
require 'json'
require 'csv'
require 'pry'

class Hash
    def +(otherHash)
        unless self.keys.sort == otherHash.keys.sort
            raise ArgumentError, "Keys must match"
        end


        result = {}
        self.keys.each do |k|
            if k == 'Name'
                result[k] = self[k] + "," + otherHash[k]
            else
                # binding.pry
                if self[k].class.ancestors.include? Hash 
                    result[k] = self[k] + otherHash[k]      # recursion!
                elsif self[k].class.ancestors.include? Array 

                    if k == "Options" and self[k].first.is_a? Array
                        result[k] = self[k] << otherHash[k]
                        # result[k].concat otherHash[k]
                    else
                        result[k] = [self[k], otherHash[k]]
                    end

                elsif self[k].class.ancestors.include? Numeric 
                    result[k] = Float(self[k]) + Float(otherHash[k])
                end
            end
        end
        result
    end
end

data = JSON.load File.open "mk8.json"

cs = data["Characters"]
vs = {}
ws = data["Wheels"]
combined = {}

data["Vehicles"]["Karts"].each_key {|k| vs["#{k} Kart"] = data["Vehicles"]["Karts"][k] }
data["Vehicles"]["Bikes"].each_key {|k| vs["#{k} Bike"] = data["Vehicles"]["Bikes"][k] }

cs.each do |ck,cv|
    vs.each do |vk, vv|
        ws.each do |wk, wv|
            puts "#{ck}, #{vk}, #{wk} Wheels"
            combined["#{ck}, #{vk}, #{wk} Wheels"] = cv + vv + wv
        end
    end
end

pry
File.open("combined.json","w") { |f| f.write JSON.generate combined }
# pp cs.first[1] + vs.first[1] + ws.first[1]
