module Isis
  
  def self.config
    Config.new
  end
  
  def self.git_dir?(path)
    File.directory?(File.join(path, ".git"))
  end
  
  class Config
    attr_reader :project_roots

    def initialize(options = {})
      @project_roots = options[:project_roots]
    end
  end
  
  class Runner
    
    def initialize()
    end
  end
    
end