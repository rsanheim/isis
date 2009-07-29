module Isis
  module HashExtensions

    def symbolize_keys
      inject({}) do |options, (key, value)|
        options[(key.to_sym rescue key) || key] = value
        options
      end
    end
  end
end

Hash.__send__ :include, Isis::HashExtensions