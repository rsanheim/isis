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
    
    it "should be false if not a directory" do
      
      
    end
  
  end
  
  
end