#!/usr/bin/env ruby
# Working with Apache 2.4 and Mac OS Sierra by SwankyLynx

HOSTS = "/etc/hosts"
VHOSTSDIR = "/etc/apache2/extra/vhosts/" # needs trailing slash

def usage
  puts "\tUSAGE: sudo vhostman add [name] [webroot path]"
end

def check_args
  if ARGV.count < 3
    usage
    exit
  elsif ARGV[0] != 'add'
    usage
    exit
  else
    @domain = ARGV[1]
    @vhost_path = VHOSTSDIR + @domain + '.conf'
    @webroot = File.expand_path ARGV[2].chomp('/')
  end
end

def check_permission
  if !File.exists? VHOSTSDIR
    puts "\tERROR: VHOSTDIR #{VHOSTSDIR} not found. Please create it."
    exit
  end
  if !File.writable? VHOSTSDIR
    puts "\tERROR: VHOSTDIR #{VHOSTSDIR} not writable. Re-run with 'sudo'."
    exit
  end
  if !File.exists? HOSTS
    puts "\tERROR: HOSTS #{HOSTS} not found."
    exit
  end
  if !File.writable? HOSTS
    puts "\tERROR: HOSTS #{HOSTS} not writable. Re-run with 'sudo'."
    exit
  end
end

def check_path
  if !File.directory?(@webroot)
    puts "\tERROR: Specified webroot dir '#{@webroot}' does not exist."
    puts "\tMake it first -> mkdir #{@webroot}"
    exit
  end
end

def check_name
  if File.exists? @vhost_path
    puts "\tERROR: Name '#{@domain}' already used."
    exit
  end
end

def make_vhost
  puts "\tMaking vhost file in #{@vhost_path}..."
  File.open(@vhost_path, 'a') do |f|
    f.puts "<VirtualHost *:80>"
    f.puts "  ServerAdmin webmaster@#{@domain}"
    f.puts "  DocumentRoot \"#{@webroot}\""
    f.puts "  ServerName #{@domain}"
    f.puts "  ServerAlias www.#{@domain}"
    f.puts "  ErrorLog \"/private/var/log/apache2/#{@domain.split(/\s|\./)[0]}-error_log\""
    f.puts "  CustomLog \"/private/var/log/apache2/#{@domain.split(/\s|\./)[0]}-access_log\" common"
    f.puts "  <Directory \"#{@webroot}\">"
    f.puts "    Options Indexes FollowSymLinks MultiViews"
    f.puts "    AllowOverride All"
    f.puts "    Require all granted"
    f.puts "  </Directory>"
    f.puts "</VirtualHost>"
  end
end

def add_to_hosts
  puts "\tAdding #{@domain} to #{HOSTS}..."
  File.open(HOSTS, 'a') do |f|
    f.puts "127.0.0.1 #{@domain}"
  end
end

def restart_apache
  puts "\tRestarting apache..."
  if !`apachectl restart`
    puts "\tERROR: Error restarting apache."
  end
end

def show_complete
  puts "\tOK! Site should be visible at http://#{@domain}"
end

# ----

check_args
check_permission
check_path
check_name
add_to_hosts
make_vhost
restart_apache
show_complete
