#
# Cookbook Name:: application
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "git"
include_recipe "sqlite"

package "libsqlite3-dev" do
  action :upgrade
end

%w{ dm-sqlite-adapter dm-core dm-timestamps dm-types dm-migrations dm-aggregates dm-validations }.each do |gem|
  ree_gem gem do
    action :install
    version "1.0.0"
  end
end
ree_gem "bcrypt-ruby" do
  action :install
  version "2.1.2"
end
ree_gem "uuidtools" do
  action :install
  version "2.1.1"
end
ree_gem "extlib" do
  action :install
  version "0.9.15"
end
ree_gem "data_objects" do
  action :install
  version "0.10.2"
end
ree_gem "do_sqlite3" do
  action :install
  version "0.10.2"
end
ree_gem "haml" do
  action :install
  version "2.2.17"
end
ree_gem "thor" do
  action :install
  version "0.9.9"
end
ree_gem "addressable" do
  action :install
  version "2.1.1"
end
ree_gem "json" do
  action :install
  version "1.1.9"
end
%w{ sinatra sinatra-authorization }.each do |gem|
  ree_gem gem do
    action :install
    version "1.0.0"
  end
end
ree_gem "bcat" do
  action :install
  version "0.5.0"
end  
ree_gem "rack" do
  action :install
  version "1.1.0"
end  
%w{ sinatra-ditties rake bcat rack }.each do |gem|
  ree_gem gem do
    action :install
  end
end

directory node[:integrity][:install_path] do
  recursive true
  action :delete
end

git node[:integrity][:install_path] do
  repository "git://github.com/integrity/integrity"
  revision "deploy v22"
  action :checkout
end

github = search(:api_tokens, "id:github").first
integrity = search(:admins, "id:integrity").first
template "#{node[:integrity][:install_path]}/init.rb" do
    source "init.rb.erb"
    variables :token => github['token'], :user => integrity['user'], :password => integrity['pass'], :base_url => node[:integrity][:server_name]
    mode 0755
    owner "deploy"
    group "deploy"    
end

%w{ log builds }.each do |dir|
  directory "#{node[:integrity][:install_path]}/#{dir}" do
    owner "deploy"
    group "deploy"
    mode 0755
    action :create
  end
end

file "#{node[:integrity][:install_path]}/Gemfile" do
  action :delete
end

execute "chown -R deploy #{node[:integrity][:install_path]}" do
end

execute "generate_database" do
  user "deploy"
  group "deploy"
  cwd "#{node[:integrity][:install_path]}"
  command "#{node[:ruby_enterprise][:install_path]}/bin/rake db"
  creates "#{node[:integrity][:install_path]}/integrity.db"
  action :run
end

include_recipe "integrity::passenger-nginx"
