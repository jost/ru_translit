# coding: utf-8
require_relative 'word'

#TODO check if a word is german or english, then don't detransliterate, right?

# Pass in a word and get some detransliteration suggestions based on our ruleset,
# which covers german and english transliterations. If softeners are to be included,
# the returned lists can get quite long.
class Detransliterator
  #returns an array of cyrillic options for the passed-in word (just one word at a time!)
  def self.cyrillic_options(input, include_softeners)
    data = Word.detransliterations_for(input, include_softeners)
    options = data[:options]
    #input_structure = data[:input_structure]
    list = Word.output_words options
  end
end