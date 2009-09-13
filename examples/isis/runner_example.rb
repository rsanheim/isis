require File.join(File.dirname(__FILE__), *%w[.. example_helper])

describe Isis::Runner do
  
  describe "run" do
    it "should return the exit code" do
      Isis::Runner.stubs(:exit).returns(256)
      Isis::Runner.any_instance.stubs(:execute)
      Isis::Runner.run.should == 256
    end
    
    it "should exit" do
      Isis::Runner.expects(:exit)
      Isis::Runner.any_instance.stubs(:execute)
      Isis::Runner.run
    end
  end

  describe "command lookup" do
    it "finds the method matching the command" do
      runner = Isis::Runner.new(["list"])
      runner.expects(:list)
      runner.execute
    end
    
    it "passes in any other options to the command" do
      runner = Isis::Runner.new(["list", "--project_roots=src/foo"])
      runner.expects(:list).with({:project_roots => "src/foo"}, [])
      runner.execute
    end
  end
  
  describe "get git repos" do
    fit "should return paths that look like git repos" do
      dot_git = stub(:directory? => true)
      git_path = stub("git_path", :children => [dot_git])
      non_git_path = stub("non_git_path", :children => ["readme"])
      paths = [git_path, non_git_path]
      Isis::Runner.filter_git_repos(paths).should == [git_path]
    end
  end
  
  describe "list" do
    
    pending "lists all git repos Isis knows about" do
      runner = Isis::Runner.new
      runner.list(:project_roots => "src/foo")
    end
    
    it "raises if project root does not exist" do
      runner = Isis::Runner.new
      lambda { 
        runner.list(:project_roots => "foo/baz") 
      }.should raise_error(ArgumentError, "Project root foo/baz is not a directory")
    end
    
    it "raises if there are no project roots" do
      runner = Isis::Runner.new
      lambda { runner.list() }.should raise_error(ArgumentError)
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
  
  describe "git repo?" do

    attr_reader :runner
    before { @runner = Isis::Runner.new }

    it "should be false if not a directory" do
      path = stub(:directory? => false)
      runner.git_repo?(path).should be_false
    end
    
    it "should be false if there is no .git entry" do
      children = [stub(:basename => stub(:to_s => "foo")), stub(:basename => stub(:to_s => "bar"))]
      path = stub(:directory? => true, :children => children)
      runner.git_repo?(path).should be_false
    end
    
    it "should be false if there is a .git file (but not a directory)" do
      children = [stub(:directory? => false, :basename => stub(:to_s => ".git")), stub(:basename => stub(:to_s => "bar"))]
      path = stub(:directory? => true, :children => children)
      runner.git_repo?(path).should be_false
    end
    
    it "should be true if there is a .git directory" do
      children = [stub(:directory? => true, :basename => stub(:to_s => ".git")), stub(:basename => stub(:to_s => "bar"))]
      path = stub(:directory? => true, :children => children)
      runner.git_repo?(path).should be_true
    end
  
  end
  
  
end