#!/usr/bin/env ruby

# DIG1=_source DIG2=data raw.json

require 'json'
require 'pry'

# Defaults:
def count(f)
  i = 1
  dig = []
  while true
    d = ENV["DIG#{i}"]
    unless d.nil? || d == ''
      dig << d
      i += 1
    else
      break
    end
  end
  dig = ['_source'] if dig.length == 0
  data = JSON.parse File.read f
  d = {}
  data.each do |row|
    ok = true
    dig.each do |d|
      if row.key?(d)
        row = row[d]
      else row.key?(d)
        ok = false
        break
      end
    end
    next unless ok
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
  puts "By column name (#{data.length}):"
  cnt.keys.sort.each do |k|
    puts "#{k}: #{cnt[k]}"
  end
  puts "\nBy distinct count (#{data.length}):"
  rcnt.keys.sort.reverse.each do |c|
      puts "#{c}: #{rcnt[c].sort.join(', ')}"
  end
end

if ARGV.size < 1
  puts "Missing argument: index_data.json"
  exit(1)
end

count(ARGV[0])

