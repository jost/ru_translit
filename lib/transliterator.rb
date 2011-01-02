# coding: utf-8
require_relative 'word'

# Pass in a word and get some transliteration suggestions based on our ruleset,
# which covers german, english and scientific transliterations.
class Transliterator
  # Returns an array of cyrillic options for the passed-in word (just one word at a time!)
  def self.translit_options(input)
    data = Word.transliterations_for(input)
    options = data[:options]
    Word.output_words options
  end
end