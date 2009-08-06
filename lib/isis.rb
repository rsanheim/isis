require 'pathname'
require 'logger'
require 'log_buddy'
LogBuddy.init

module Isis
  
  def self.logger
    @logger ||= Logger.new(File.join(File.dirname(__FILE__), *%w[.. tmp isis.log]))
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
