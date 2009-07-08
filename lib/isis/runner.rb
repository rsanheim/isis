module Isis
  
  class Runner
  
    def self.run
      runner = new(ARGV[1..-1])
      runner.send(ARGV[0]) if ARGV[0]
      exit 0
    end
  
    def initialize(args)
      STDERR.puts args
    end
  
    def list
      results = all_git_repos.inject(Hash.new) do |results, repo|
        results[repo] = system "git", "--git-dir=#{repo}", "fetch"
        results
      end
      results.values.all?
    end
  
    def all_git_repos
    end
  end

end