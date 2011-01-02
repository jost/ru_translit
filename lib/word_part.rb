# coding: utf-8
require_relative 'translit_rules'
require_relative 'detranslit_rules'

class WordPart
  attr_accessor :input, :prev, :succ, :static_output, :just_thru #may be more restricted than this
  @prev, @succ = nil
  @just_thru = false
  @input = nil
  @is_detranslit = nil
  
  # arrays: [output, predecessor-rule, successor-rule]
  DT_RULES = DetranslitRules.rules
  T_RULES = TranslitRules.rules
  
  def initialize input, prev, detranslit=true
    @input = input
    @prev = prev
    @is_detranslit = detranslit
  end
  
  def self.has_rules? input, is_detranslit
    if is_detranslit
      DT_RULES.has_key? input
    else
      T_RULES.has_key? input
    end
  end
  
  #return array of (cyrillic) strings which can be empty (or nil instead?) --should we cache the result? i think it's called no more than once.
  def cyrillic_options(include_softeners)
    return [input] if just_thru #this can be set to accomodate for untranslatable characters.
    ret = []
    arr = @is_detranslit ? DT_RULES[input] : T_RULES[input]
    if arr #there are rules for this part, now see if any of them match
      arr.each do |rule|
        if match?(rule, include_softeners)
          ret << rule[0]
        end
      end
    end
    ret
  end
  
private  
  def match?(rule, include_softeners) #rule is expected to be an array of the form [output, prev-rule, succ-rule, priority(0 is for softeners)]
    prev_input = prev.nil? ? '' : prev.input
    succ_input = succ.nil? ? '' : succ.input
    (prev_input =~ rule[1]) && (succ_input =~ rule[2]) && (rule[3]>0 || include_softeners)
  end

end