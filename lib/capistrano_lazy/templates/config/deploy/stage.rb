set :rails_env, "<%= @environment %>"
set :app_directory, "<%= @deploy_directory %>/current"
set :unicorn_pid_file, "#{fetch(:app_directory)}/tmp/pids/<%= @pid_file %>"

deployer = "<%= @deploy_user %>"
<% @deploy_hosts = ["localhost"] if @deploy_hosts.nil? || @deploy_hosts.empty? %>
hosts = %w{
  <%= @deploy_hosts.join(" ") %>
}
proc = lambda { |host| deployer + "@" + host }

role :app, hosts.map(&proc)
role :web, hosts.map(&proc)

hosts.each do |host|
  server host, user: deployer, roles: %w{web app}
end

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options
