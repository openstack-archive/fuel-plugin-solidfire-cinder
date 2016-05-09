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
class plugin_cinder_solidfire::backend::rbd (
  $rbd_pool                         = 'volumes',
  $rbd_user                         = 'volumes',
  $rbd_ceph_conf                    = '/etc/ceph/ceph.conf',
  $rbd_flatten_volume_from_snapshot = false,
  $rbd_secret_uuid                  = 'a5d0dd94-57c4-ae55-ffe0-7e3732a24455',
  $volume_tmp_dir                   = false,
  $rbd_max_clone_depth              = '5',
  $glance_api_version               = undef,
  $backend_type,
) {

  cinder_config {
    'cinder_rbd/volume_backend_name':              value => $backend_type;
    'cinder_rbd/volume_driver':                    value => 'cinder.volume.drivers.rbd.RBDDriver';
    'cinder_rbd/rbd_ceph_conf':                    value => $rbd_ceph_conf;
    'cinder_rbd/rbd_user':                         value => $rbd_user;
    'cinder_rbd/rbd_pool':                         value => $rbd_pool;
    'cinder_rbd/rbd_max_clone_depth':              value => $rbd_max_clone_depth;
    'cinder_rbd/rbd_flatten_volume_from_snapshot': value => $rbd_flatten_volume_from_snapshot;
    'cinder_rbd/backend_host':                     value => "rbd:${rbd_pool}";
  }

  ini_subsetting {'enable_cinder_rbd_backend':
    ensure             => present,
    section            => 'DEFAULT',
    key_val_separator  => '=',
    path               => '/etc/cinder/cinder.conf',
    setting            => 'enabled_backends',
    subsetting         => "cinder_iscsi",
    subsetting_separator => ',',
  }

}
