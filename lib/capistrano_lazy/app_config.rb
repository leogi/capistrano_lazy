module CapistranoLazy
  class AppConfig
    include TemplateHelper

    attr_accessor :settings

    def initialize
      @settings = Option.load File.expand_path("deploy.yml")
    end

    def config!
      cp_capfile
      cp_deploy
      cp_deploy_env
      cp_unicorn
    end

    private
    def cp_capfile
      template File.expand_path("../templates/Capfile", __FILE__),
        "Capfile"
    end

    def cp_deploy
      template File.expand_path("../templates/config/deploy.rb", __FILE__),
        "config/deploy.rb", {
          application: @settings.application,
          repo_url: @settings.repo_url,
          deploy_directory: @settings.deploy.directory
        }
    end

    def cp_deploy_env
      template File.expand_path("../templates/config/deploy/stage.rb", __FILE__),
        "config/deploy/staging.rb", {
          environment: "staging",
          deploy_directory: @settings.deploy.directory,
          pid_file: @settings.unicorn.pid_file,
          deploy_hosts: @settings.deploy.hosts,
          deploy_user: @settings.deploy.user
        }
      template File.expand_path("../templates/config/deploy/stage.rb", __FILE__),
        "config/deploy/production.rb", {
          environment: "production",
          deploy_directory: @settings.deploy.directory,
          pid_file: @settings.unicorn.pid_file,
          deploy_hosts: @settings.deploy.hosts,
          deploy_user: @settings.deploy.user
        }
    end

    def cp_unicorn
      template File.expand_path("../templates/config/unicorn.rb", __FILE__),
        "config/unicorn.rb", {
          application: @settings.application,
          deploy_directory: @settings.deploy.directory,
          worker_processes: @settings.unicorn.worker_processes,
          unicorn_port: @settings.unicorn.port,
          sock_file: @settings.unicorn.sock_file,
          pid_file: @settings.unicorn.pid_file
        }
    end
  end
end