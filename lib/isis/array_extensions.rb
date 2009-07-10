module Isis
  # Thanks to Chris Wanstrath's Rip for the nice array (ie ARGV) parsing idea
  module ArrayExtensions
    def parse_as_args
      args = self.clone
      command = args.shift
      options = args.select { |piece| piece =~ /^-/ }
      args   -= options
      options = options.inject({}) do |hash, flag|
        key, value = flag.split('=')
        hash[key.sub(/^--?/,'').intern] = value.nil? ? true : value
        hash
      end

      [command, options, args]
    end
  end
end

Array.__send__ :include, Isis::ArrayExtensions