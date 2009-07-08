require 'pathname'
require Pathname.new(__FILE__)

describe Isis::Runner do
  
  describe "run" do
    
    it "should return the exit code" do
      Isis::Runner.stubs(:exit).returns(256)
      Isis::Runner.run.should == 256
    end
    
    it "should exit" do
      Isis::Runner.expects(:exit)
      Isis::Runner.run
    end
    
  end
  
  describe "list" do
    
    it "runs git fetch inside each directory within every git repo" do
      runner = Isis::Runner.new
      runner.expects(:all_git_repos).returns(["/projectx", "/projecty"])
      runner.expects(:system).with("git", "--git-dir=/projectx", "fetch").returns(true)
      runner.expects(:system).with("git", "--git-dir=/projecty", "fetch").returns(true)
      runner.list.should == true
    end
    
    it "returns false if any of the fetches fail" do
      runner = Isis::Runner.new
      runner.expects(:all_git_repos).returns(["/projectx", "/projecty"])
      runner.stubs(:system).returns(true, false)
      runner.list.should == false
    end
    
  end
  
end