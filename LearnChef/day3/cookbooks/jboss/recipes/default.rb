#
# Cookbook:: jboss
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
#

include_recipe 'java'
package 'unzip'

# Jboss user
user 'jboss' do
  # User for jboss service'
  uid '1212'
  shell '/bin/bash'
end

# Downloading jboss
# source 'http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.zip'
remote_file './jboss.zip' do
  source 'https://kent.dl.sourceforge.net/project/jboss/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip'
  show_progress true
end

# Unzip Jboss.zip
bash 'unarchive' do
  code <<-EOH
    mkdir -p /opt/jboss
    unzip jboss.zip -d /opt
    cp -r /opt/jboss-5.1.0.GA/* /opt/jboss/
    chown -R jboss:jboss /opt/jboss
    EOH
end

# Jboss systemd
template '/etc/systemd/system/jboss.service' do
  source 'jboss.service.erb'
  mode '0744'
end

# Jboss service
service 'jboss' do
  action [:enable, :start]
end

# Copy from templates "server.xml"
data = data_bag_item('confeg','jb_port')
template '/opt/jboss/server/default/deploy/jbossweb.sar/server.xml' do
  source "server.xml.erb"
  owner 'jboss'
  group 'jboss'
  variables(newport: data['port'])
  mode 0644
end

remote_file '/opt/jboss/server/default/deploy/sample.war' do
#  source 'https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war'
  source "#{node['hello_link']}"
end

service 'jboss' do
  action :restart
end
