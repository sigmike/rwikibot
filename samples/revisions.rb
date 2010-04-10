#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__), "..", "lib")

require 'rubygems'
require 'rwikibot'
require 'yaml'
require 'pp'

if ARGV.empty?
  [
    "usage: #$0 <parameter>=<value> [<parameter>=<value>...]",
    "Examples:",
    "  #$0 titles=Foo limit=3",
    "  #$0 titles=Foo rvlimit=3",
    "Allowed parameters are listed here: http://www.mediawiki.org/wiki/API:Query_-_Properties#revisions_.2F_rv",
  ].each do |line|
    STDERR.puts line
  end
  exit 1  
end

parameters = Hash[*ARGV.map { |arg| arg.split("=") }.flatten]

config = YAML.load(File.read("bot.yml"))


bot = RWikiBot.new config["user"], config["password"], config["api_path"]
result = bot.revisions(parameters)
pp result
