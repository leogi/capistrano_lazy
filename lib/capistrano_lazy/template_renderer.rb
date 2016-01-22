module CapistranoLazy
  class TemplateRenderer
    attr_accessor :template

    def initialize filepath, options = {}
      @template = load filepath
      options.each do |key, value|
        instance_variable_set "@#{key.to_s}", value
      end
    end

    def render
      ERB.new(@template).result binding
    end

    def export filepath
      prepare_dir filepath

      puts "\e[32mCreate\e[0m #{filepath}"
      File.open(filepath, "w+") do |f|
        f.write render
      end
    end

    private
    def prepare_dir filepath
      dirname = File.dirname filepath
      unless File.directory? dirname
        FileUtils.mkdir_p dirname
      end
    end

    def load filepath
      realpath = File.realpath filepath
      File.open(realpath).read
    end
  end
end