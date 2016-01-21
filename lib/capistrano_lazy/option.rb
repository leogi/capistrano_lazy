require "ostruct"
require "yaml"

module CapistranoLazy
  class Option < OpenStruct
    def initialize hash=nil
      super(hash)
    end

    class << self
      def load filepath
        parse YAML.load(File.read(filepath))
      end

      def parse hash
        return hash unless hash.is_a? Hash

        options = Option.new hash
        hash.each do |key, value|
          if value.is_a? Hash
            value = parse hash[key]
          elsif value.is_a? Array
            value = value.collect { |v| v.is_a?(Hash) ? parse(v) : v }
          end

          options.send "#{key}=", value
        end
        options
      end
    end
  end
end