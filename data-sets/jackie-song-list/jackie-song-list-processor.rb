#!/usr/bin/env ruby
#
require 'rails'
require 'json'
require 'yaml'


SUBSTITUTIONS = {
    'A '     => 'a ',
    'And '   => 'and ',
    'Egbert'   => 'Eggbert',
    'For '   => 'for ',
    'From '  => 'from ',
    'In '    => 'in ',
    'Of '    => 'of ',
    'Or '    => 'or ',
    'The '   => 'the ',
    'Heart S'  => "Heart's",
    'Nothing For Christmas' => "Nuttin' for Christmas"
}

original_lines = File.readlines('jackie-song-list-original.txt')

titles = original_lines.map do |line| \
  line.split('.') \
  .last \
  .strip \
  .gsub(/^DON T/, "Don't") \
  # Remove " (From movie name)":
  .gsub(/\s+\(FROM:? .*\)/, '') \
  .titleize
end

titles.reject!(&:empty?)

titles.map! do |title|
  SUBSTITUTIONS.each { |from, to| title.gsub!(from, to) }
  title[0] = title[0].upcase  # Need to recapitalize those tokens at start of title, e.g. "In Italy"
  title
end

titles.sort!
titles.uniq!

titles -= [
    'Am I Ready?',
    'Angel (From "Follow That Dream")',
    'I Know a Boy',
    'Susie Snowflake',    # duplicate of Suzy Snowflake
    'When The Boy In Your Arms', # dup. of 'When the Girl...'
]

File.write('jackie-song-list-processed.txt', titles.join("\n"))
File.write('jackie-song-list-processed.json', JSON.pretty_generate(titles))
File.write('jackie-song-list-processed.yaml', titles.to_yaml)

puts "Done. #{original_lines.size} -> #{titles.size} titles."
