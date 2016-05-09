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

class plugin_cinder_solidfire::controller (
    $backend_name  = 'solidfire',
    $backends      = ''
) {

    include cinder::params
    include cinder::client

    $cinder_solidfire = hiera_hash('cinder_solidfire', {})

    if $::cinder::params::volume_package {
      package { $::cinder::params::volume_package:
        ensure => present,
      }
      Package[$::cinder::params::volume_package] -> Cinder_config<||>
    }

    $section = $backend_name
    cinder_config {
      "DEFAULT/enabled_backends": value => "${backend_name},${backends}";
    }

    cinder::backend::solidfire { $backend_name :
      san_ip               => $cinder_solidfire['solidfire_mvip'],
      san_login            => $cinder_solidfire['solidfire_admin_login'],
      san_password         => $cinder_solidfire['solidfire_admin_password'],
      volume_backend_name  => $backend_name,
      sf_emulate_512       => $cinder_solidfire['solidfire_emulate_512'],
      sf_api_port          => $cinder_solidfire['solidfire_api_port'],
      sf_account_prefix    => $cinder_solidfire['solidfire_account_prefix'],
      extra_options        => { "${backend_name}/sf_allow_template_caching"  =>
          { value => $cinder_solidfire['solidfire_allow_template_caching'] },
                                  "${backend_name}/sf_template_account_name" =>
                { value => $cinder_solidfire['solidfire_template_account'] },
                                                      "${backend_name}/host" =>
                                                      { value => $backend_name },
                              },
    }

    Cinder_config<||>~> Service[cinder_volume]

    service { 'cinder_volume':
      ensure     => running,
      name       => $::cinder::params::volume_service,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }

    package { 'open-iscsi' :
      ensure => 'installed',
    }

}
