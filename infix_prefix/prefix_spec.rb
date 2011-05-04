require 'rspec'
require_relative '../prefix'

describe String do

  it "is_digit? works as advertised" do
    "31".is_digit?.should == true
    '3a'.is_digit?.should == false
  end

end

describe Prefixer do

  describe 'prefix' do

    it "3 becomes   3" do
      Prefixer.prefix('3').should == '3'
      Prefixer.prefix('3',true).should == 3
    end

    it "1 + 1 becomes   + 1 1" do
      Prefixer.prefix('1 + 1').should == '+ 1 1'
      Prefixer.prefix('1 + 1',true).should == 2
    end

    it "2 * 5 + 1  becomes   + 1 * 2 5" do
      Prefixer.prefix('2 * 5 + 1').should == '+ * 2 5 1'
      Prefixer.prefix('2 * 5 + 1',true).should == 11
    end

    it "2 * ( 5 + 1 )  becomes  * 2 + 5 1" do
      Prefixer.prefix('2 * ( 5 + 1 )').should == '* 2 + 5 1'
      Prefixer.prefix('2 * ( 5 + 1 )',true).should == 12
    end

    it "3 * x + ( 9 + y ) / 4  becomes    + * 3 x / + 9 y 4" do
      Prefixer.prefix('3 * x + ( 9 + y ) / 4').should == '+ * 3 x / + 9 y 4'
      Prefixer.prefix('3 * x + ( 9 + y ) / 4',true).should == '+ * 3 x / + 9 y 4'
    end
  end

end

