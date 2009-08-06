require 'pathname'
require 'logger'
require 'log_buddy'
LogBuddy.init

module Isis
  
  TMP_DIR = Pathname.new(__FILE__).dirname.join("..", "tmp").expand_path

  def self.logger
    @logger || @logger = init_logger
  end
  
  def self.init_logger
    TMP_DIR.mkdir unless TMP_DIR.exist?
    Logger.new(TMP_DIR.join("isis.log"))
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
