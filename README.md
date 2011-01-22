# ru_translit

A simple Object with two class methods for transliterating russian cyrillic words to latin,
and for detransliterating transliterated words from latin back to cyrillic. At this point,
it does not follow any one specific transliteration ruleset, but uses a variation of German,
English and (simplified) scientific transliteration rules. It is meant to be a very pragmatic, catch-all
way of getting different real-world variants of how a given word might be transliterated or detransliterated.
Each of the two methods returns an array of words.

The detransliteration method has an optional second parameter that decides whether the returned
cyrillic options should include those whose only difference to another option is that it includes one
or more softeners, which are usually not transliterated. This parameter defaults to false.

What's special about this is that it takes the context of letters in the word into account in order to find out
whether certain options are to be included. Most other transliteration tools don't do this.

## Install

    gem install ru_translit
