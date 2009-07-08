$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'isis'
require 'tempfile'
require File.join(File.dirname(__FILE__), *%w[ruby_forker])

require 'micronaut/expectations'

module CucumberHelpers
  include RubyForker

  def working_dir
    @working_dir ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../tmp/cucumber-generated-files"))
  end

  def spec_command
    @spec_command ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../bin/isis"))
  end

  def cmdline_file
    @cmdline_file ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../resources/helpers/cmdline.rb"))
  end

  def rspec_lib
    @rspec_lib ||= File.join(working_dir, "/../../lib")
  end

  def spec(args)
    ruby("#{spec_command} #{args}")
  end

  def cmdline(args)
    ruby("#{cmdline_file} #{args}")
  end

  def create_file(file_name, contents)
    file_path = File.join(working_dir, file_name)
    File.open(file_path, "w") { |f| f << contents }
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
    stderr_file = Tempfile.new('rspec')
    stderr_file.close
    Dir.chdir(working_dir) do
      @stdout = super("-I #{rspec_lib} #{args}", stderr_file.path)
    end
    @stderr = IO.read(stderr_file.path)
    @exit_code = $?.to_i
  end
  
  extend self

end

World(Micronaut::Matchers)
World(CucumberHelpers)


Before do
  FileUtils.rm_rf   CucumberHelpers.working_dir if test ?d, CucumberHelpers.working_dir
  FileUtils.mkdir_p CucumberHelpers.working_dir
end
