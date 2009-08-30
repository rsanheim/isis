$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'isis'
require 'tempfile'
require 'pathname'
require 'tmpdir'

require 'spec/expectations'

require File.join(File.dirname(__FILE__), *%w[ruby_forker])
require File.join(File.dirname(__FILE__), *%w[smart_match])


module CucumberHelpers
  include RubyForker

  def working_dir
    @working_dir ||= Pathname.new(Dir::tmpdir).join("working_dir_for_cucumber")
  end

  def isis_command
    @spec_command ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../bin/isis"))
  end

  def cmdline_file
    @cmdline_file ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../resources/helpers/cmdline.rb"))
  end

  def rspec_lib
    @rspec_lib ||= File.join(working_dir, "/../../lib")
  end

  def isis(args)
    ruby("#{isis_command} #{args}")
  end

  def cmdline(args)
    ruby("#{cmdline_file} #{args}")
  end

  def create_file(file_name, contents)
    file_path = File.join(working_dir, file_name)
    File.open(file_path, "w") { |f| f << contents }
  end
  
  def create_directory(dir_name)
    dir_path = File.join(working_dir, dir_name)
    FileUtils.mkdir_p dir_path
  end

  def create_git_repo(path)
    git_path = Pathname.new(working_dir).join(path)
    git_path.mkdir
    dot_git_dir = git_path.join(".git").expand_path
    system! "git --git-dir=#{dot_git_dir} init --quiet"
  end
  
  def system!(cmd)
    system(cmd) || raise("Error executing '#{cmd}'")
  end
  
  def last_stdout
    @stdout
  end

  def last_stderr
    @stderr
  end

  def last_exit_code
    @exit_code
  end

  # it seems like this, and the last_* methods, could be moved into RubyForker-- is that being used anywhere but the features?
  def ruby(args)
    stderr_file = Tempfile.new('isis')
    stderr_file.close
    Dir.chdir(working_dir) do
      @stdout = super("-I #{rspec_lib} #{args}", stderr_file.path)
    end
    @stderr = IO.read(stderr_file.path)
    @exit_code = $?.to_i
  end
  
  extend self

end

# World(Micronaut::Matchers)
World(CucumberHelpers)

Before do
  FileUtils.rm_rf   CucumberHelpers.working_dir if test ?d, CucumberHelpers.working_dir
  FileUtils.mkdir_p CucumberHelpers.working_dir
end
