#
# Cookbook Name:: selenium
# Recipe:: IEDriver
# Author:: Guilhem Lettron <guilhem.lettron@youscribe.com>
#
# Copyright 2012, Societe Publica.
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

unless node['platform'] == "windows"
  ark "chromedriver" do
    url node['selenium']['chromedriver']['url']
    path node['selenium']['chromedriver']['directory']
    creates "chromedriver"
    action :cherry_pick
  end
else
  cache_dir = Chef::Config[:file_cache_path]
  zip_path = "#{cache_dir}\\#{node['selenium']['chromedriver']['zip_file']}"
  source_url = "#{node['selenium']['chromedriver']['url']}"
  install_dir = "#{node['selenium']['chromedriver']['directory']}"
  chromedriver = "#{install_dir}\\chromedriver.exe"
  
  remote_file "#{zip_path}" do
    source "#{source_url}"
    action :create_if_missing
  end

  windows_zipfile "#{install_dir}" do
    source "#{zip_path}"
    path  "#{install_dir}"
    action :unzip
    not_if {::File.exists?(chromedriver)}
  end

end
