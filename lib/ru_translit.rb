require 'unicode_utils/downcase'
require 'transliterator'
require 'detransliterator'

# Transliteration as well as De-/Retransliteration between russian cyrillic and
# English, German and Scientific transliterations. Accounts for context-dependent
# transliteration rules.
# Current limitations:
# * Only one word per pass.
# * Everything will be downcased.
# * No distinction between the different translit variants: Just one list with all possible options gets returned.
module RuTranslit
  #def self.included base
  #  base.extend ClassMethods
  #end

#  module ClassMethods
    # De-transliterates a single latin word to cyrillic. returns an array of possible cyrillic strings
    # if include_softeners is true, variations including only the positioning of softeners get added
    # to the returned array as well. considers mainly German and English transliteration variants.
    def self.to_cyrillic latin_term, include_softeners=false
      latin_term = UnicodeUtils.downcase(latin_term) #generally, the regular downcase should be fine here, but doesn't hurt like this.
      Detransliterator.cyrillic_options(latin_term, include_softeners)
    end

    # Transliterates a single cyrillic word to latin. Returns an array of possible latin strings.
    # Considers mainly English, German and scientific (mostly minus the diacritics) transliteration variants.
    def self.to_latin cyrillic_term
      cyrillic_term = UnicodeUtils.downcase(cyrillic_term) #generally, the regular downcase should be fine here, but doesn't hurt like this.
      Transliterator.translit_options(cyrillic_term)
    end

    # Short forms of the main methods.
    alias to_cy to_cyrillic
    alias to_la to_latin
#  end
end
