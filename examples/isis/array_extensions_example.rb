require File.join(File.dirname(__FILE__), *%w[.. example_helper])

describe "Arg parsing" do

  it "works" do
    %w( install -f ).parse_as_args.should == ["install", { :f => true }, []]
    %w( install -f=force ).parse_as_args.should == ["install", {:f => "force"}, []]
    %w( install -f force name ).parse_as_args.should == ["install", { :f => true }, [ "force", "name" ]]
    %w( install something ).parse_as_args.should == ["install", {}, [ "something" ]]
  end
  
end
