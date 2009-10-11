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
    "  #$0 user=Foo limit=3",
    "  #$0 ucuser=Foo uclimit=3",
    "  #$0 ucuserprefix=Foo dir=newer",
    "Allowed parameters are listed here: http://www.mediawiki.org/wiki/API:Query_-_Lists#usercontribs_.2F_uc",
  ].each do |line|
    STDERR.puts line
  end
  exit 1  
end

parameters = Hash[*ARGV.map { |arg| arg.split("=") }.flatten]

config = YAML.load(File.read("bot.yml"))


bot = RWikiBot.new config["user"], config["password"], config["api_path"]
contributions = bot.contributions(parameters)
pp contributions
