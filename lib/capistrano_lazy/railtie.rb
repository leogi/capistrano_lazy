require "rails"

module CapistranoLazy
  class Railtie < Rails::Railtie
    rake_tasks do
      import File.expand_path("../../tasks/config.rake", __FILE__)
    end
  end
end