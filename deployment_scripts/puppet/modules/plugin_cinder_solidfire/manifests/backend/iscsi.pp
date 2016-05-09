#
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
class plugin_cinder_solidfire::backend::iscsi (
  $volume_group = 'cinder',
  $iscsi_helper = $cinder::params::iscsi_helper,
  $backend_type,
) inherits cinder::params {

  $network_scheme = hiera_hash('network_scheme', {})
  prepare_network_config($network_scheme)

  $storage_address = get_network_role_property('cinder/iscsi', 'ipaddr')

  cinder_config {
    'cinder_iscsi/volume_backend_name': value => $backend_type;
    'cinder_iscsi/volume_driver':       value => 'cinder.volume.drivers.lvm.LVMVolumeDriver';
    'cinder_iscsi/iscsi_helper':        value => $iscsi_helper;
    'cinder_iscsi/volume_group':        value => $volume_group;
    'cinder_iscsi/iscsi_ip_address':    value => $storage_address;
    'cinder_iscsi/backend_host':        value => $storage_address;
  }

  ini_subsetting {'enable_cinder_iscsi_backend':
    ensure             => present,
    section            => 'DEFAULT',
    key_val_separator  => '=',
    path               => '/etc/cinder/cinder.conf',
    setting            => 'enabled_backends',
    subsetting         => "cinder_iscsi",
    subsetting_separator => ',',
  }
}
