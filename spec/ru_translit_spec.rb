#coding: utf-8
require 'ru_translit'

describe RuTranslit do
  before(:each) do
    @la_str = 'something'
    @cy_str = 'что-то'
    @cy_str2 = 'биографиями'
    @nr = '123'
  end

  it "should respond to the two main methods for transliteration and detransliteration" do
    RuTranslit.should respond_to('to_latin')
    RuTranslit.should respond_to('to_cyrillic')
  end

  it "should respond to some short or alternative forms for the two main methods" do
    RuTranslit.should respond_to('to_la')
    RuTranslit.should respond_to('to_cy')
    RuTranslit.should respond_to('transliterate')
    RuTranslit.should respond_to('detransliterate')
  end

  it "should return an array containing only the input when given a lowercase latin string to transliterate" do
    RuTranslit.to_latin(@la_str).should be_an_instance_of(Array)
    RuTranslit.to_latin(@la_str).should have(1).items
    RuTranslit.to_latin(@la_str).first.should == @la_str
  end

  it "should return an array containing only the input when given a lowercase cyrillic string to detransliterate" do
    RuTranslit.to_latin(@cy_str).should be_an_instance_of(Array)
    RuTranslit.to_latin(@cy_str).should have_at_least(1).items
    RuTranslit.to_cyrillic(@cy_str).first.should == @cy_str
  end

  it "should leave numbers alone in both directions" do
    RuTranslit.to_latin(@nr).should have(1).item
    RuTranslit.to_latin(@nr).first.should == @nr
    RuTranslit.to_cyrillic(@nr).should have(1).item
    RuTranslit.to_cyrillic(@nr).first.should == @nr
  end

  it "should preserve latin word-parts while transliterating cyrillic word-parts" do
    RuTranslit.to_latin(@cy_str + @la_str + @cy_str).first.should =~ /#{@la_str}/
  end

  it "should return a list of several transliterations for the russian word 'биографиями'" do
    RuTranslit.to_latin(@cy_str2).should have_at_least(2).items
    RuTranslit.to_latin(@cy_str2).should have_at_most(4).items #making sure it doesn't explode for some reason
  end

  it "should return (among others) the original input if we do a 'round-trip' cy->la->cy, using the first result" do
    RuTranslit.to_cyrillic(RuTranslit.to_latin(@cy_str2).first).should include(@cy_str2)
  end

  it "should return (among others) the original input if we do a 'round-trip' la->cy->la, using the first result" do
    RuTranslit.to_latin(RuTranslit.to_cyrillic(@la_str).first).should include(@la_str)
  end

  it "should offer cyrillic alternatives for 'schtsch', at least one of which should be only one letter long" do
    RuTranslit.to_cyrillic('schtsch').should include('щ')
  end

  it "should return different transliteration results depending on context in some cases" do
    RuTranslit.to_latin('де').should include('de')
    RuTranslit.to_latin('де').should_not include('dje')
    RuTranslit.to_latin('е').should include('je')
  end

  it "should include softeners in the detransliteration results (only) if called with the appropriate argument" do
    RuTranslit.to_cyrillic('f', false).should_not include('фь')
    RuTranslit.to_cyrillic('f', true).should include('фь')
  end

end

