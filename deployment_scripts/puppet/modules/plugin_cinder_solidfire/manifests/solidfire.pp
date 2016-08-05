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
define plugin_cinder_solidfire::solidfire (
  $backend_name        = $name,
  $cinder_solidfire    = $plugin_cinder_solidfire::cinder_solidfire,
) {

    include cinder::params
    include cinder::client

    Cinder::Backend::Solidfire <||> -> Plugin_cinder_solidfire::Enable_backend[$backend_name] ~> Service <||>

    cinder::backend::solidfire { $backend_name :
      san_ip               => $cinder_solidfire['solidfire_mvip'],
      san_login            => $cinder_solidfire['solidfire_admin_login'],
      san_password         => $cinder_solidfire['solidfire_admin_password'],
      volume_backend_name  => $backend_name,
      sf_emulate_512       => 'true',
      sf_api_port          => $cinder_solidfire['solidfire_api_port'],
      sf_account_prefix    => $cinder_solidfire['solidfire_account_prefix'],
      sf_allow_template_caching  => $cinder_solidfire['solidfire_allow_template_caching'],
      sf_template_account_name  => $cinder_solidfire['solidfire_template_account'],
      sf_volume_prefix    => $cinder_solidfire['solidfire_volume_prefix'],
      extra_options        => { "${backend_name}/host" =>
                                                   { value => $backend_name },
                              },
    }

    plugin_cinder_solidfire::enable_backend { $backend_name: }

    package { 'open-iscsi' :
      ensure => 'installed',
    }

    service { $cinder::params::volume_service: }

}
