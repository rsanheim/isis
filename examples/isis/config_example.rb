require File.join(File.dirname(__FILE__), *%w[.. example_helper])

describe Isis::Config do
  
  it "should have project roots" do
    config = Isis::Config.new(:project_roots => ["/src/private", "/src/public"])
    config.project_roots.should == ["/src/private", "/src/public"]
  end
  
  describe "project roots" do
    
    it "should combine project root arrays" do
      Isis::Config.any_instance.stubs(:config_from_yaml).returns({:project_roots => ["foo", "bar"]})
      config = Isis::Config.new(:project_roots => ["/src", "/things"])
      config.project_roots.should == %w[/src /things bar foo]
    end
    
    it "should sort project roots" do
      config = Isis::Config.new(:project_roots => ["zzz", "moo", "bark"])
      config.project_roots.should == %w[bark moo zzz]
    end
  end
  
  describe "config from yaml" do

    it "should symbolize keys" do
      Pathname.any_instance.stubs(:exist?).returns(true)
      YAML.stubs(:load_file).with(anything).returns({"project_roots" => ["foo", "bar"]})
      Isis::Config.new.config_from_yaml.should == {:project_roots => ["foo", "bar"]}
    end
    
    it "should load config from yaml if the config exists" do
      Pathname.any_instance.expects(:exist?).returns(true)
      YAML.expects(:load_file).with(anything).returns({:project_roots => ["foo", "bar"]})
      Isis::Config.new
    end
  
    it "should never try to load yaml if config file does not exist" do
      Pathname.any_instance.expects(:exist?).returns(false)
      YAML.expects(:load_file).never
      Isis::Config.new
    end
    
  end

end