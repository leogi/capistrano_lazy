require "capistrano_lazy/version"
require "capistrano_lazy/option"
require "capistrano_lazy/template_helper"
require "capistrano_lazy/app_config"
require "capistrano_lazy/server_config"
require "capistrano_lazy/railtie" if defined?(Rails)

module CapistranoLazy
end