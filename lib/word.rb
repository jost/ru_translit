# coding: utf-8
require_relative 'word_part'

@@max_checked_string_length = 7 # To accomodate 'schtsch' or s.th like that.

class Word
  def self.detransliterations_for(word, include_softeners, is_detranslit=true)
    last_part = build_word_part_structure word, is_detranslit
    first_part = add_link_to_succ_to_each_word_part(last_part)
    input_structure = word_input_structure(first_part)
    wps_options = [] #this will be filled with lists of possible cyrillic output (2d-array then)
    part = first_part
    until part.nil? do
      wps_options << part.cyrillic_options(include_softeners)
      part = part.succ
    end
    {:input_structure => input_structure, :options => wps_options}
  end

  def self.transliterations_for(word)
    self.detransliterations_for(word, true, false)
  end
  
  #transform 2d-options-array two an array of cyrillic words.
  def self.output_words part_options
    part_options.map!{|a| a.size==0 ? nil : a} #delete empty option arrays
    part_options.compact!
    get_part_combinations '', part_options, []
  end

  
private
  #builds a singly linked list, and returns the last item
  def self.build_word_part_structure word, is_detranslit
    rest_size = [word.size-@@max_checked_string_length,0].max #size of the chunk from the beginning of word to be checked for any matching wordparts
    offset = 0 #offset from the beginning of the word --do we need this at all?
    cy_result = ""
    prev_wp = nil #previous wordpart (relative to current. nil for first wordpart)
    while(word && word.size>0) do
      #in die liste schaun. wenn ja, dann offset = rest_size
      chunk = word[0..(-1-rest_size)]
      if WordPart.has_rules?(chunk, is_detranslit) #if there are rules for this chunk
        wp = WordPart.new(chunk, prev_wp, is_detranslit)#cy_result << new_cy_char
        prev_wp = wp
        offset = word.size-rest_size
        #offset += 1 if chunk.size == 0 #move to the next letter if the current one has no cyrillic equivalent
        word = word[(offset)..-1] #cut the word to the rest of the string that has to be put into the wp-structure
        rest_size = [word.size-@@max_checked_string_length,0].max
        #logger.debug "~~: "+cy_result
      elsif chunk.size > 0 #no rules found, so make chunk one letter shorter
        rest_size += 1
      else #no rules found and chunk is empty. meaning: no rules for the current word's first character. which means: just keep it.
        offset = word.size-rest_size+1
        wp = WordPart.new(word[0..offset-1], prev_wp, is_detranslit)
        prev_wp = wp
        wp.just_thru = true
        word = word[(offset)..-1]
        #rest_size = 0
        rest_size = [word.size-@@max_checked_string_length,0].max
      end
      #logger.debug ">>>: rest_size = "+rest_size.to_s+", offset = "+offset.to_s+", word = "+word
    end
    prev_wp
  end
  
  #go thru the linked list and add the next to each (except the last of course). return the first.
  def self.add_link_to_succ_to_each_word_part last
    part = last
    until part.prev.nil? do
      prev = part.prev
      prev.succ = part
      part = prev
    end
    part
  end
  
  #just for debugging: return an array of the input parts, how the input has been split into wordparts
  def self.word_input_structure first_part
    ret = []
    part = first_part
    until part.nil? do
      ret << part.input
      part = part.succ
    end
    ret
  end
  
  #go through the 2d-array of wordpart-options and build a list of words from all possible combinations  
  def self.get_part_combinations(str, arr_in, arr_out)
    if arr_in.size == 0
      arr_out << str
      return arr_out
    end
    cur_arr = arr_in[0]
    cur_arr.each do |w|
      w2 = str == "" ? w : str + w
      arr_out = arr_out | get_part_combinations(w2, arr_in[1..-1], arr_out) #merge the two arrays. may be faster with just adding, not merging, since there won't be any duplicates anyway
    end
    arr_out
  end

end