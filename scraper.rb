#!/bin/env ruby
# encoding: utf-8

require 'json'
require 'pry'
require 'rest-client'
require 'scraperwiki'
require 'wikidata/fetcher'
require 'cgi'

def candidates
  morph_api_url = 'https://api.morph.io/tmtmtmtm/poland-sejm-wikipedia/data.json'
  morph_api_key = ENV["MORPH_API_KEY"]
  result = RestClient.get morph_api_url, params: {
    key: morph_api_key,
    query: "select wikidata from data"
  }
  JSON.parse(result, symbolize_names: true)
end

info = candidates
candidates.each_with_index do |p,i|
  puts i if (i % 100).zero?
  next if p[:wikidata].empty?
  data = WikiData::Fetcher.new(id: p[:wikidata]).data('pl') or next
  # puts "%s %s" % [data[:id], data[:name]]
  ScraperWiki.save_sqlite([:id], data)
end

