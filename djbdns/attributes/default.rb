#
# Cookbook Name:: djbdns
# Recipe:: default
# Author:: Joshua Timberman (<joshua@opscode.com>)
# Author:: Joshua Sierles (<joshua@37signals.com>)
#
# Copyright 2009, Opscode, Inc
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

default[:djbdns][:tinydns_ipaddress]          = "127.0.0.1"
default[:djbdns][:tinydns_internal_ipaddress] = "127.0.0.1"
default[:djbdns][:public_dnscache_ipaddress]  = ipaddress
default[:djbdns][:axfrdns_ipaddress]          = "127.0.0.1"

default[:djbdns][:axfrdns_uid]  = 9996
default[:djbdns][:dnscache_uid] = 9997
default[:djbdns][:dnslog_uid]   = 9998
default[:djbdns][:tinydns_uid]  = 9999


default[:djbdns][:public_dnscache_allowed_networks] = [ipaddress.split(".")[0,2].join(".")]
default[:djbdns][:tinydns_internal_resolved_domain] = domain

case platform
when "ubuntu"
  if platform_version >= "8.10"
    set[:djbdns][:bin_dir] = "/usr/bin"
  else
    set[:djbdns][:bin_dir] = "/usr/local/bin"
  end 
when "debian"
  if platform_version >= "5.0"
    set[:djbdns][:bin_dir] = "/usr/bin"
  else
    set[:djbdns][:bin_dir] = "/usr/local/bin"
  end 
else
    set[:djbdns][:bin_dir] = "/usr/local/bin"
end
