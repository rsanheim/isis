$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'isis'

require 'micronaut/expectations'

module CucumberHelpers

  def create_file(file_name, contents)
    file_path = File.join(working_dir, file_name)
    File.open(file_path, "w") { |f| f << contents }
  end

  def working_dir
    @working_dir ||= File.expand_path(File.join(File.dirname(__FILE__), "/../../tmp/cucumber-generated-files"))
  end

  extend self
end

World(Micronaut::Matchers)
World(CucumberHelpers)


Before do
  FileUtils.rm_rf   CucumberHelpers.working_dir if test ?d, CucumberHelpers.working_dir
  FileUtils.mkdir_p CucumberHelpers.working_dir
end
