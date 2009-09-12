require 'open4'

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
      root_paths = get_project_roots(options)
      repos = []
      root_paths.each do |root_path|
        root_path.children.each do |path|
          repos << path.basename if git_repo?(path)
        end
      end
      puts "Known git repos: #{repos.sort.join(", ")}"
    end
    
    def status(options = {}, args = [])
      Isis.logger.debug options
      root_paths = get_project_roots(options)
      repos = []
      root_paths.each do |root_path|
        root_path.children.each do |path|
          repos << path.basename if git_repo?(path)
        end
      end
      out = "Status of git repos: #{repos.join(", ")}\n"
      repos.each do |repo|
        Isis.logger.debug "Getting status of: #{repo.expand_path}"
        cmd = "git --git-dir=#{repo.expand_path} status"
        stdout, stderr = nil, nil
        status = Open4.popen4(cmd) do |_pid, _stdin, _stdout, _stderr|
          _stdin.close
          stdout = _stdout.read.strip
          
          stderr = _stderr.read.strip
        end
        out << "#{repo}: "
        out << stdout
        out << stderr
      end
      puts out
    end
    
    def get_project_roots(options)
      project_roots = options[:project_roots] || raise(ArgumentError, "No project roots found")
      project_root_pathnames = Array(project_roots).map do |path| 
        # TODO refactor with returning?
        pathname = Pathname.new(path) 
        raise(ArgumentError, "Project root #{path} is not a directory") unless pathname.directory?
        pathname
      end
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