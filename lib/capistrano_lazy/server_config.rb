require "fileutils"
require "securerandom"

module CapistranoLazy
  class ServerConfig
    include TemplateHelper

    attr_accessor :settings

    def initialize
      @settings = Option.load File.expand_path("deploy.yml")
    end

    def config!
      prepare_deploy_directory
      cp_database
      cp_secret
      cp_nginx
      cp_unicorn
    end

    private
    def cp_database
      template File.expand_path("../templates/config/database.yml", __FILE__),
        "config/database.yml", {
          environment: @settings.environment,
          database_name: @settings.database.name,
          database_host: @settings.database.host,
          database_username: @settings.database.username,
          database_password: @settings.database.password
        }

      puts "\e[33mInstall\e[0m #{@settings.deploy.directory}/shared/config/database.yml"
      FileUtils.cp "config/database.yml", "#{@settings.deploy.directory}/shared/config"
    end

    def cp_secret
      template File.expand_path("../templates/config/secrets.yml", __FILE__),
        "config/secrets.yml", {
          environment: @settings.environment,
          secret_key_base: SecureRandom.hex(64)
        }

      puts "\e[33mInstall\e[0m #{@settings.deploy.directory}/shared/config/secrets.yml"
      FileUtils.cp "config/secrets.yml", "#{@settings.deploy.directory}/shared/config"
    end

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
        puts "\e[33mInstall\e[0m /etc/nginx/sites-enabled/#{@settings.application}"
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
      puts "\e[33mInstall\e[0m /etc/init.d/#{@settings.application}"
      `sudo mv unicorn_#{@settings.application} /etc/init.d/`
      `sudo chmod +x /etc/init.d/unicorn_#{@settings.application}`
    end

    def prepare_deploy_directory
      if !File.exists? "/var/www"
        `sudo mkdir /var/www`
      end

      if !File.exists? @settings.deploy.directory
        `sudo mkdir /var/www/#{@settings.application}`
        `sudo chown #{@settings.deploy.user}:#{@settings.deploy.groupuser} /var/www/#{@settings.application}`
        `chmod 755 /var/www/#{@settings.application}`
      end

      if !File.exists? "#{@settings.deploy.directory}/shared/config"
        puts "\e[32mCreate\e[0m #{@settings.deploy.directory}/shared/config"
        FileUtils.mkdir_p "#{@settings.deploy.directory}/shared/config"
      end
    end
  end
end