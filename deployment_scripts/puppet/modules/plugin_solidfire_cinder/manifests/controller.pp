#    Copyright 2015 SolidFire, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#

class plugin_solidfire_cinder::controller (
    $backend_name  = 'solidfire',
    $backends      = ''
) {

    include cinder::params
    include cinder::client
    
    $plugin_settings = hiera('fuel-plugin-solidfire-cinder')
    
    if $::cinder::params::volume_package {
      package { $::cinder::params::volume_package:
        ensure => present,
      }
      Package[$::cinder::params::volume_package] -> Cinder_config<||>
    }
    
    if $plugin_settings['multibackend'] {
      $section = $backend_name
      cinder_config {
        "DEFAULT/enabled_backends": value => "${backend_name},${backends}";
      }
    } else {
      $section = 'DEFAULT'
    }

    cinder::backend::solidfire { $section :
      san_ip                      => $plugin_settings['solidfire_mvip'],
      san_login                   => $plugin_settings['solidfire_admin_login'],
      san_password                => $plugin_settings['solidfire_admin_password'],
      volume_backend_name         => $section,
      sf_emulate_512              => $plugin_settings['solidifre_emulate_512'],
      sf_api_port                 => $plugin_settings['solidfire_api_port'],
      # due to a non-update of the puppet modules in version 6.1 of fuel we need to set this
      volume_driver               => 'cinder.volume.drivers.solidfire.SolidFireDriver'
    } 
    
    Cinder_config<||>~> Service[cinder_volume]

    service { 'cinder_volume':
      ensure     => running,
      name       => $::cinder::params::volume_service,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
    
}
