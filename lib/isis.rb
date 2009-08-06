require 'pathname'
require 'logger'
require 'log_buddy'
LogBuddy.init

module Isis
  
  def self.root_path
    Pathname.new(ENV["HOME"]).join(".isis")
  end
  
  def self.logger
    @logger || @logger = init_logger
  end
  
  def self.init_logger
    root_path.mkdir unless root_path.exist?
    Logger.new(root_path.join("isis.log"))
  end
  
  def self.config
    Config.new
  end
  
  def self.git_dir?(path)
    File.directory?(File.join(path, ".git"))
  end
  
end  

require 'isis/array_extensions'
require 'isis/hash_extensions'
require 'isis/config'
require 'isis/runner'
