require File.join(File.dirname(__FILE__), *%w[example_helper])

describe Isis do
  
  describe "top level" do
    it "has top level" do
      Isis
    end
  
    it "has top level config" do
      Isis.config.should be_instance_of(Isis::Config)
    end
  end
  
  it "should be a git dir if it has a .git dir" do
    File.expects(:directory?).with("/src/private/projectx/.git").returns(false)
    config = Isis.git_dir?("/src/private/projectx").should be_false
  end 

  describe Isis::Runner do
    it "should be able to fetch all" do
      isis = Isis::Runner.new

    end
    
  end
  
  describe Isis::Config do

    it "should have project roots" do
      config = Isis::Config.new(:project_roots => ["/src/private", "/src/public"])
      config.project_roots.should == ["/src/private", "/src/public"]
    end
    
  end
end
