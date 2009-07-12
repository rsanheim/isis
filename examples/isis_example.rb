require File.join(File.dirname(__FILE__), *%w[example_helper])

describe Isis do
  
  describe "top level" do
    it "has top level" do
      Isis
    end
  
    it "has top level config" do
      Isis.config.should be_instance_of(Isis::Config)
    end
    
    describe "with real config file" do

      def config_01
        File.expand_path(File.join(File.dirname(__FILE__), *%w[.. fixtures config_01]))
      end
      
      it "should read project roots" do
        isis = Isis::Config.new(:config_file_path => config_01)
        isis.project_roots.should == %w[~/src/oss ~/src/priv/relevance]
      end
      
      it "should combine project roots from config with anything passed in" do
        config_01 = File.expand_path(File.join(File.dirname(__FILE__), *%w[.. fixtures config_01]))
        isis = Isis::Config.new(:config_file_path => config_01, :project_roots => ["/src/root/projects"])
        isis.project_roots.should == %w[/src/root/projects ~/src/oss ~/src/priv/relevance]
      end
    end
  end
  
  it "should be a git dir if it has a .git dir" do
    File.expects(:directory?).with("/src/private/projectx/.git").returns(false)
    Isis.git_dir?("/src/private/projectx").should be_false
  end 

end
