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
class plugin_cinder_solidfire {

  $cinder_solidfire = hiera_hash('cinder_solidfire', {})
  $storage_hash  = hiera_hash('storage_hash', {})
  $plugins = hiera('plugins', [] )

  if ($storage_hash['volume_backend_names']['volumes_lvm']) {
    $backend_type        = $storage_hash['volume_backend_names']['volumes_lvm']
    $backend_name        = 'cinder_iscsi'
    $volume_backend_name = 'volumes_lvm'
    $backend_class       = 'plugin_cinder_solidfire::backend::iscsi'
  } elsif ($storage_hash['volume_backend_names']['volumes_ceph']) {
    $backend_type        = $storage_hash['volume_backend_names']['volumes_ceph']
    $backend_name        = 'cinder_rbd'
    $volume_backend_name = 'volumes_ceph'
    $backend_class       = 'plugin_cinder_solidfire::backend::rbd'
  }

  if ( 'cinder_netapp' in $plugins ) {
    plugin_cinder_solidfire::backend::solidfire { 'solidfire': backend_name => 'solidfire', }
  } else {
    class { $backend_class: backend_type => $backend_type, } 
    plugin_cinder_solidfire::backend::solidfire { 'solidfire': backend_name => 'solidfire', }
  }

}
