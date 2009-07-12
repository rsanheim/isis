module Isis
  
  class Runner
    
    def self.run
      runner = new(ARGV)
      runner.execute
      exit 0
    end
  
    def initialize(args = [])
      @args = args
    end
    
    def execute
      options_from_config = Isis::Config.new.config_from_yaml
      command, options, args = @args.parse_as_args
      options = options_from_config.merge(options)
      send(command, options, args)
    end
  
    def list(options = {}, args = [])
      Isis.logger.debug options
      root = options[:project_roots] || raise(ArgumentError, "No project roots found")
      root_path = Pathname.new(root)
      raise(ArgumentError, "Project root #{root_path} is not a directory") unless root_path.directory?
      repos = []
      root_path.children.each do |path|
        repos << path.basename if git_repo?(path)
      end
      puts "Known git repos: #{repos.sort.join(", ")}"
    end
    
    def fetch_all
      results = all_git_repos.inject({}) do |results, repo|
        results[repo] = system "git", "--git-dir=#{repo}", "fetch"
        results
      end
      results.values.all?
    end
  
    def all_git_repos
      []
    end
    
    def git_repo?(path)
      return false unless path.directory?
      !! path.children.detect do |p| 
        p.basename.to_s == ".git" && p.directory?
      end
    end
  end

end