#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

names = EveryPolitician::Wikidata.morph_wikinames(source: 'tmtmtmtm/poland-sejm-wikipedia', column: 'wikipedia__pl')

# Find all relevant P39s
query = <<EOS
  SELECT DISTINCT ?item WHERE { ?item wdt:P39 wd:Q19269361 }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { pl: names })

