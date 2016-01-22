require "erb"
require "fileutils"
require "capistrano_lazy/template_renderer"

module CapistranoLazy
  module TemplateHelper
    def template source_file, destination_file, options = {}
      TemplateRenderer.new(source_file, options).export destination_file
    end
  end
end