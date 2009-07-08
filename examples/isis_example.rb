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
    config = Isis.git_dir?("/src/private/projectx").should be_false
  end 

  describe Isis::Runner do
    
    describe "run" do
      
      it "should return instance of runner" do
        Isis::Runner.run.should be_instance_of(Isis::Runner)
      end
      
    end
    
    describe "all git repos" do
      
      it "should return all git repos that exist one level down in project roots" do
        runner = Isis::Runner.new
        runner.all_git_repos.should == ["/src/foo"]
      end
      
    end
      
    describe "fetch all" do
      
      it "runs git fetch inside each directory within every git repo" do
        runner = Isis::Runner.new
        runner.expects(:all_git_repos).returns(["/projectx", "/projecty"])
        runner.expects(:system).with("git", "--git-dir=/projectx", "fetch").returns(true)
        runner.expects(:system).with("git", "--git-dir=/projecty", "fetch").returns(true)
        runner.fetch_all.should == true
      end
      
      it "returns false if any of the fetches fail" do
        runner = Isis::Runner.new
        runner.expects(:all_git_repos).returns(["/projectx", "/projecty"])
        runner.stubs(:system).returns(true, false)
        runner.fetch_all.should == false
      end
      
    end
    
  end
  
  describe Isis::Config do

    it "should have project roots" do
      config = Isis::Config.new(:project_roots => ["/src/private", "/src/public"])
      config.project_roots.should == ["/src/private", "/src/public"]
    end
    
    describe "project roots" do
      
      it "should combine project root arrays" do
        Isis::Config.any_instance.stubs(:config_from_yaml).returns({"project_roots" => ["foo", "bar"]})
        config = Isis::Config.new(:project_roots => ["/src", "/things"])
        config.project_roots.should == %w[/src /things bar foo]
      end
      
      it "should sort project roots" do
        config = Isis::Config.new(:project_roots => ["zzz", "moo", "bark"])
        config.project_roots.should == %w[bark moo zzz]
      end
    end
    
    describe "config from yaml" do
      
      it "should load config from yaml if the config exists" do
        File.expects(:exists?).with("~/.isis").returns(true)
        YAML.expects(:load_file).with(anything).returns({:project_roots => ["foo", "bar"]})
        Isis::Config.new
      end
    
      it "should never try to load yaml if config file does not exist" do
        File.expects(:exists?).returns(false)
        YAML.expects(:load_file).never
        Isis::Config.new
      end
      
    end
    
  end
end
