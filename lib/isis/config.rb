module Isis
  class Config
    attr_reader :project_roots

    def self.default_config_file
      Pathname.new("#{ENV['HOME']}/.isis.yml").expand_path
    end
    
    def initialize(options = {})
      @config_file_path = Pathname.new(options[:config_file_path] || self.class.default_config_file)
      Isis.logger.debug("Using config file path: #{@config_file_path}")
      Isis.logger.debug("Does config exist? #{File.exists?(@config_file_path)}")
      project_roots = options[:project_roots] || []
      @project_roots = project_roots.concat(config_from_yaml[:project_roots] || []).sort
    end
  
    def config_from_yaml
      if @config_file_path.exist? 
        YAML.load_file(@config_file_path).symbolize_keys
      else
        {}
      end
    end
  
  end
end