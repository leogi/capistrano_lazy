module CapistranoLazy
  class ServerConfig
    include TemplateHelper

    attr_accessor :settings

    def initialize
      @settings = Option.load File.expand_path("deploy.yml")
    end

    def config!
      cp_nginx
      cp_unicorn
    end

    private
    def cp_nginx
      server_names = @settings.server_names
      server_names = ["_"] if server_names.nil? || server_names.compact.empty?
      template File.expand_path("../templates/nginx_site", __FILE__),
        "nginx_#{@settings.application}", {
          environment: @settings.environment,
          application: @settings.application,
          server_names: server_names.join(","),
          deploy_directory: @settings.deploy.directory,
          unicorn_host: @settings.unicorn.host,
          unicorn_port: @settings.unicorn.port
        }
        
      if File.exists? "/etc/nginx"
        unless File.exists? "/etc/nginx/sites-enabled"
          `sudo mkdir /etc/nginx/sites-enabled`
        end
        `sudo mv nginx_#{@settings.application} /etc/nginx/sites-enabled/#{@settings.application}`
      else
        puts "Nginx is not found. Please install nginx first."
      end
    end

    def cp_unicorn
      template File.expand_path("../templates/unicorn_script", __FILE__),
        "unicorn_#{@settings.application}", {
          environment: @settings.environment,
          application: @settings.application,
          deploy_directory: @settings.deploy.directory,
          deploy_user: @settings.deploy.user,
          pid_file: @settings.unicorn.pid_file
        }
      `sudo mv unicorn_#{@settings.application} /etc/init.d/`
      `sudo chmod +x /etc/init.d/unicorn_#{@settings.application}`
    end
  end
end