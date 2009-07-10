require 'pathname'

module Isis
  
  def self.config
    Config.new
  end
  
  def self.git_dir?(path)
    File.directory?(File.join(path, ".git"))
  end
  
  def all_git_repos
    
  end
  
  class Config
    attr_reader :project_roots

    def initialize(options = {})
      @config_file_path = options[:config_file_path] || "~/.isis"
      project_roots = options[:project_roots] || []
      @project_roots = project_roots.concat(config_from_yaml["project_roots"] || []).sort
    end
    
    def config_from_yaml
      File.exists?(@config_file_path) ? YAML.load_file(@config_file_path) : {}
    end
    
  end
end  

require 'isis/array_extensions'
require 'isis/runner'
