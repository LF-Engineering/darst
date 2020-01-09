#!/usr/bin/env ruby

require 'json'
require 'pry'

# Defaults:
# SKIP_KEYS: metadata__updated_on,metadata__timestamp,metadata__enriched_on
# KEYS: grimoire_creation_date
def compare(f1, f2)
  data = []
  data[0] = JSON.parse File.read f1
  data[1] = JSON.parse File.read f2
  data.each_with_index do |d, i|
    if d.count == 0
      puts "No data in ##{i+1} file"
      exit 1
    end
    data[i] = d.map { |row| row['_source'] }
  end
  all = {}
  all_keys = []
  data.each_with_index do |d, i|
    all_keys[i] = {}
    d.each_with_index do |row, r|
      ks = row.keys.sort
      ks.each do |k| 
        all_keys[i][k] = 0 unless all_keys[i].key?(k)
        all_keys[i][k] += 1
        all[k] = 0 unless all.key?(k)
        all[k] += 1
      end
    end
  end
  ks = all.keys.sort.join(',')
  ks1 = all_keys[0].keys.sort
  ks2 = all_keys[1].keys.sort
  if ks1 != ks2
    puts "WARNING: different key sets:\n#{ks1}\nnot equal to:\n#{ks2}"
  end
  vals1 = all_keys[0].values.uniq
  vals2 = all_keys[1].values.uniq
  puts "Unique key presence counts in 1st file: #{vals1}"
  puts "Unique key presence counts in 2nd file: #{vals2}"
  skip_keys = ENV['SKIP_KEYS']
  if skip_keys.nil? || skip_keys == ''
    skip_keys = 'metadata__updated_on,metadata__timestamp,metadata__enriched_on'
  elsif skip_keys == "-"
    skip_keys = ''
  end
  skip_keys = skip_keys.split(',').map(&:strip)
  skip = {}
  skip_keys.each do |k|
    skip[k] = true
  end
  keys = ENV['KEYS']
  if keys.nil? || keys == ''
    puts "You should specify keys to check via KEYS='key1,key2,...,keyN', available keys:\n#{ks}"
    puts "You can also specify special value ALLKEYS"
    puts "You can specify non-standard keys to skip, default are: metadata__updated_on,metadata__timestamp,metadata__enriched_on"
    puts "To specify them use SKIP_KEYS='key1,key2,...,keyN', use 'SKIP_KEYS=- to disable skipping anything"
    puts "Will use default key: grimoire_creation_date"
    keys = 'grimoire_creation_date'
  end
  if keys == 'ALLKEYS'
    keys = ks.split(',')
  else
    keys = keys.split(',').map(&:strip)
  end
  keys.each do |k|
    next if skip.key?(k)
    values = []
    data.each_with_index do |d, i|
      values[i] = {}
      d.each_with_index do |row, r|
        v = (row[k] || '(nil)').to_s
        values[i][v] = true
      end
    end
    miss1 = {}
    miss2 = {}
    values[1].keys.each do |k|
      unless values[0].key?(k)
        miss1[k] = true
      end
    end
    values[0].keys.each do |k|
      unless values[1].key?(k)
        miss2[k] = true
      end
    end
    if miss1.count > 0 || miss2.count > 0
      puts "Key: #{k}"
    end
    if miss1.count > 0
      puts "Values from 2nd file missing in 1st file: #{miss1.keys.sort.join(',')}"
    end
    if miss2.count > 0
      puts "Values from 1st file missing in 2nd file: #{miss2.keys.sort.join(',')}"
    end
  end
end

if ARGV.size < 2
  puts "Missing arguments: index_data_1.json index_data_2.json"
  exit(1)
end

compare(ARGV[0], ARGV[1])
