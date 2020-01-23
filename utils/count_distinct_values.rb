#!/usr/bin/env ruby

# DIG1=_source DIG2=data raw.json
# FILTER1=type=comment FILTER2=is_bot=1
# OUT=fn.json

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
  filters = {}
  i = 1
  while true
    fv = ENV["FILTER#{i}"]
    unless fv.nil? || fv == ''
      ary = fv.split '='
      i += 1
      next unless ary.length == 2
      filters[ary[0]] = ary[1]
    else
      break
    end
  end
  out = []
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
    ok = true
    filters.each do |k, v|
      if !row.key?(k)
        ok = false
        break
      elsif row[k] != v
        ok = false
        break
      end
    end
    next unless ok
    out << row
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
  wrt = ENV["OUT"]
  unless wrt.nil? || wrt == ''
    pretty = JSON.pretty_generate out
    File.write wrt, pretty
  end
end

if ARGV.size < 1
  puts "Missing argument: index_data.json"
  exit(1)
end

count(ARGV[0])

