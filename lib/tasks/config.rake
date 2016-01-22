require "capistrano_lazy"

namespace :capistrano do
  namespace :lazy do
    task :install do
      include CapistranoLazy::TemplateHelper
      template File.expand_path("../../capistrano_lazy/templates/deploy.yml", __FILE__),
        "deploy.yml"
    end

    task :setup do
      CapistranoLazy::AppConfig.new.config!
    end

    namespace :deploy do
      task :install do
      end
    end
  end
end