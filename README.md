# CapistranoLazy

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/capistrano_lazy`. To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capistrano_lazy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano_lazy

## Usage

### 1. Add gem:

```
gem 'unicorn'
gem 'unicorn-worker-killer'
gem 'capistrano', '3.1.0'
gem 'capistrano-rbenv'
gem 'capistrano-bundler', github: 'capistrano/bundler'
gem 'capistrano-rails'
gem "capistrano_lazy"
```

### 2. Run command to generate deploy.yml file:

```
rake capistrano:lazy:install
```

```
# HOME -- deploy.yml
environment: production
application: capistrano_lazy
repo_url: https://bitbucket.org/nghialv/capistrano_lazy
deploy:
  directory: /var/www/capistrano_lazy
  user: deploy
  groupuser: dev
  hosts: 
    - localhost
  pid_file: unicorn_capistrano_lazy.pid
unicorn:
  worker_processes: 4
  sock_file: unicorn_capistrano_lazy.sock
  pid_file: unicorn_capistrano_lazy.pid
  host: localhost
  port: 5889
nginx:
  domains: 
database:
  host: localhost
  name: capistrano_lazy
  username: root
  password:
```

### 3. After edit deploy.yml, run below command to generate all config file.

```
rake capistrano:lazy:setup
```

```
HOME 
  -- Capfile
  ++ config
     -- deploy.rb
     -- unicorn.rb
     ++ deploy
        -- staging.rb
        -- production.rb
```

### 4. In production server, run command to setup nginx, unicorn, and deploy directory

```
rake capistrano:lazy:deploy:setup
```

```
database.yml
secrets.yml
nginx_site
unicorn_script
```
### 5. Enjoin to deploy with capistrano command.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capistrano_lazy.
