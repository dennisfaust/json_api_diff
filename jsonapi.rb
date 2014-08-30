#!/usr/bin/env ruby
# require 'bundler/setup'
# Bundler.require(:default)
require 'thor'
require 'byebug'
require 'json'
require 'hashdiff'
require 'uri'
require 'net/http'

class JsonApi < Thor
  desc "USAGE: #{self.to_s.downcase} diff",
    'Compare JSON responses from another host to URLs given in stdin.'   # usage, description
  option :other_host, required: true
  def diff
    $stdin.each_line do |line|
      uri = URI(line)
      # begin 
        primary = JSON.parse(Net::HTTP.get_response(uri).body)
        other_uri = URI("#{options[:other_host]}#{uri.path}?#{uri.query}")
        other = JSON.parse(Net::HTTP.get_response(other_uri).body)
      # rescue => e
        # puts e
      # end
      puts ("Primary: #{primary}")
      puts ("Other: #{other}")
      puts HashDiff.diff(primary, other)
      # GC.start
    end
  end
end

JsonApi.start(ARGV)
