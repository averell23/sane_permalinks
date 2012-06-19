require './lib/sane_permalinks'


module ActiveRecord
  class Base

    def to_param ; '23' ; end

  end

  class RecordNotFound < Exception ; end
end

describe SanePermalinks do

  before(:all) { SanePermalinks.init }

  let(:fake_class) { Class.new(ActiveRecord::Base) }

  let(:fake_model) { fake_class.new }


  describe "the default behaviour" do

    it "should implement #find_by_param to call #find_by_id"  do
      fake_class.should_receive(:find_by_id).with(123).and_return('hello')
      fake_class.find_by_param(123).should == 'hello'
    end

    it "should just call the superclass to get the param" do
      fake_model.to_param.should == '23'
    end

  end

  describe "the behaviour when using a permalink field" do

    it "should implement #find_by_param to call #find_by_{field_name}" do
      fake_class.send(:make_permalink, :with => :foobar)
      fake_class.should_receive(:find_by_foobar).with('helloworld').and_return('hello')
      fake_class.find_by_param('helloworld').should == 'hello'
    end

    it "should implement the #to_param method to return the field content" do
      fake_class.send(:make_permalink, :with => 'barfoo')

      fake_model.should_receive(:barfoo).with(no_args).and_return('hello')
      fake_model.to_param.should == 'hello'
    end

  end

  describe "the behaviour when using prepend_id" do

    it "should search by id" do
      fake_class.send(:make_permalink, :with => :foobar, :prepend_id => true)

      fake_class.should_receive(:find_by_id).with(23).and_return('hello')
      fake_class.find_by_param('23-barfoo').should == 'hello'
    end

    it "should generate a nice param" do
      fake_class.send(:make_permalink, :with => :foobar, :prepend_id => true)

      fake_model.should_receive(:foobar).and_return('hello_world')

      fake_model.to_param.should == '23-hello_world'
    end

    it "should raise an error when finding by a wrong permalink, if required" do
      fake_class.send(:make_permalink, :with => :foobar, :prepend_id => true, :raise_on_wrong_permalink => true)
      fake_result = fake_class.new

      fake_class.should_receive(:find_by_id).and_return(fake_result)
      fake_result.should_receive(:to_param).and_return('23-abc')

      expect { fake_class.find_by_param('23-hello') }.to raise_error(SanePermalinks::WrongPermalink)
    end

  end

  describe "find_by_param as an exclamation mark method" do

    it "should raise an exception if nothing is found" do
      fake_class.should_receive(:find_by_param).and_return(nil)

      expect { fake_class.find_by_param!(123) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "should work normally if a record is found" do
      fake_class.should_receive(:find_by_param).and_return('something')
      fake_class.find_by_param!(123).should == 'something'
    end

  end

  describe "sanitizing params" do

    it "should do the standard escaping" do
      fake_model.sanitize_param("Ín der Öder pf'ügén víé-le Hüöänér!\"!_:;§$%").should == "in-der-oder-pf-ugen-vie-le-huoaner-ss-percent"
    end

  end


end