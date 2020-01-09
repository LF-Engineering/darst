#!/usr/bin/env ruby

require 'csv'
require 'pry'

def compare(f1, f2)
  d1 = {}
  puts "\nCheck for empty indexes"
  CSV.foreach(f1, headers: true) do |row|
    i = row['index']
    v = row['count'].to_i
    if v == 0
      puts "1st file: index #{i} has no documents"
    else
      d1[i] = v
    end
  end
  d2 = {}
  CSV.foreach(f2, headers: true) do |row|
    i = row['index']
    v = row['count'].to_i
    if v == 0
      puts "2nd file: index #{i} has no documents"
    else
      d2[i] = v
    end
  end

  # index presence differences
  puts "\nIndex count differences"
  miss1 = {}
  miss2 = {}
  d2.keys.each do |k|
    unless d1.key?(k)
      miss1[k] = true
    end
  end
  ks = {}
  enrich_ks = {}
  d1.keys.each do |k|
    unless d2.key?(k)
      miss2[k] = true
    else
      ks[k] = true
      enrich_ks[k] = true unless k.end_with?('-raw')
    end
  end
  if miss1.count > 0
    puts "#{miss1.count} indexes from 2nd file missing in 1st file:\n#{miss1.keys.sort.join("\n")}"
  end
  if miss2.count > 0
    puts "#{miss2.count} indexes from 1st file missing in 2nd file:\n#{miss2.keys.sort.join("\n")}"
  end
  ks = ks.keys
  enrich_ks = enrich_ks.keys

  # internal end external raw vs. enriched count differences
  puts "\nRaw vs enriched count differences for both files"
  rawe = {}
  [d1, d2].each_with_index do |d, i|
    enrich_ks.each do |k|
      skip = false
      ['-jira', '-gerrit', '-discourse'].each do |suffix|
        if k.end_with?(suffix)
          skip = true
          break
        end
      end
      next if skip
      rk = "#{k}-raw"
      v = d[k]
      rv = d[rk]
      unless v == rv
        df = 100.0 * (v - rv).abs.to_f / [v, rv].min.to_f
        s = sprintf "#%d file: %s raw/enriched diff %.4f%%: %d != %d\n", i+1, k, df, rv, v
        puts s
        rawe[df] = [] unless rawe.key?(df)
        ary = rawe[df]
        ary << s
        rawe[df] = ary
      end
    end
  end
  puts "\nRaw vs enriched count differences for both files (sorted by the biggest difference)"
  rawe.keys.sort.reverse.each do |k|
    puts rawe[k]
  end

  # external vs. internal index documents counts differences
  puts "\nIndex documents count differences between both files"
  intext = {}
  ks.each do |k|
    skip = false
    ['-github-repository', '-github-repository-raw', '-dockerhub', '-dockerhub-raw'].each do |suffix|
      if k.end_with?(suffix)
        skip = true
        break
      end
    end
    next if skip
    v1 = d1[k]
    v2 = d2[k]
    unless v1 == v2
      df = 100.0 * (v1 - v2).abs.to_f / [v1, v2].min.to_f
      s = sprintf "%s diff %.4f%%: %d != %d\n", k, df, v1, v2
        puts s
      intext[df] = [] unless intext.key?(df)
      ary = intext[df]
      ary << s
      intext[df] = ary
    end
  end
  puts "\nIndex documents count differences between both files (sorted by the biggest difference)"
  intext.keys.sort.reverse.each do |k|
    puts intext[k]
  end
end

if ARGV.size < 2
  puts "Missing arguments: ext.csv int.csv"
  exit(1)
end

compare(ARGV[0], ARGV[1])
