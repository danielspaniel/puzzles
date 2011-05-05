require 'rspec'
require_relative 'infix'

describe String do

  it "is_number? works as advertised" do
    "31".is_number?.should == true
    '3a'.is_number?.should == false
  end

end

describe Infix do

  describe "3" do

    before :all do
      @infix = Infix.new('3')
    end

    it "to prefix notation is '3'" do
      @infix.prefix.should == '3'
    end

    it "reduced prefix notation is 3" do
      @infix.prefix(true).should == 3
    end
  end

  describe "1 + 1 " do

    before :all do
      @infix = Infix.new("1 + 1")
    end

    it "to prefix notation is '+ 1 1'" do
      @infix.prefix.should == "+ 1 1"
    end

    it "reduced prefix notation is 2" do
      @infix.prefix(true).should == 2
    end
  end

  describe "2 * 5 + 1" do

    before :all do
      @infix = Infix.new("2 * 5 + 1")
    end

    it "to prefix notation is '+ * 2 5 1'" do
      @infix.prefix.should == "+ * 2 5 1"
    end

    it "reduced prefix notation is 11" do
      @infix.prefix(true).should == 11
    end
  end

  describe "2 * ( 5 + 1 )" do

    before :all do
      @infix = Infix.new("2 * ( 5 + 1 )")
    end

    it "to prefix notation is '* 2 + 5 1'" do
      @infix.prefix.should == "* 2 + 5 1"
    end

    it "reduced prefix notation is 12" do
      @infix.prefix(true).should == 12
    end
  end

  describe "3 * x + ( 9 + y ) / 4" do

    before :all do
      @infix = Infix.new("3 * x + ( 9 + y ) / 4")
    end

    it "to prefix notation is '+ * 3 x / + 9 y 4'" do
      @infix.prefix.should == "+ * 3 x / + 9 y 4"
    end

    it "reduced prefix notation is '+ * 3 x / + 9 y 4'" do
      @infix.prefix(true).should == '+ * 3 x / + 9 y 4'
    end
  end

end

