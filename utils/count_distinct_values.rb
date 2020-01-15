#!/usr/bin/env ruby

require 'json'
require 'pry'

# Defaults:
def count(f)
  data = JSON.parse File.read f
  d = {}
  data.each do |row|
    next unless row.key?('_source')
    row = row['_source']
    row.each do |col, val|
      d[col] = {} unless d.key?(col)
      d[col][val] = true
    end
  end
  cnt = {}
  rcnt = {}
  d.each do |col, vals|
    c = vals.keys.count
    cnt[col] = c
    rcnt[c] = [] unless rcnt.key?(c)
    rcnt[c] = rcnt[c] << col
  end
  puts "By column name:"
  cnt.keys.sort.each do |k|
    puts "#{k}: #{cnt[k]}"
  end
  puts "\nBy distinct count:"
  rcnt.keys.sort.reverse.each do |c|
      puts "#{c}: #{rcnt[c].sort.join(', ')}"
  end
end

if ARGV.size < 1
  puts "Missing argument: index_data.json"
  exit(1)
end

count(ARGV[0])

