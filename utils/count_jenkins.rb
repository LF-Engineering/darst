#!/usr/bin/env ruby

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
  jobs = {}
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
    job = row['job_name']
    jobs[job] = {} unless jobs.key?(job)
    build = row['build'].to_i
    jobs[job][build] = {}
  end
  builds = {}
  sum_builds = 0
  puts "Distinct jobs: #{jobs.keys.count}"
  jobs.keys.sort.each do |job|
    puts "#{job} #{jobs[job].keys.count}"
    jobs[job].keys.each do |build|
      builds[build] = {}
      sum_builds += build
    end
  end
  puts "Distinct job ids: #{builds.keys.count}"
  puts "Sum job ids: #{sum_builds}"
end

if ARGV.size < 1
  puts "Missing argument: index_data.json"
  exit(1)
end

count(ARGV[0])
