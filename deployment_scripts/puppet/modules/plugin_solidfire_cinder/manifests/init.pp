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

class plugin_solidfire_cinder {

    include cinder::params

    if $::fuel_settings['fuel-plugin-solidfire-cinder']['multibackend'] {
      $section = 'cinder_solidfire'
    } else {
      $section = 'DEFAULT'
    }

    if $::cinder::params::volume_package {
      package { $::cinder::params::volume_package:
        ensure => present,
      }
      Package[$::cinder::params::volume_package] -> Cinder_config<||>
    }

    cinder_config { 
      "${section}/volume_driver":                            value => 'cinder.volume.drivers.solidfire.SolidFireDriver';
      "${section}/san_login":                                value => $::fuel_settings['fuel-plugin-solidfire-cinder']['solidfire_admin_login'];
      "${section}/san_password":                             value => $::fuel_settings['fuel-plugin-solidfire-cinder']['solidfire_admin_password'];
      "${section}/san_ip":                                   value => $::fuel_settings['fuel-plugin-solidfire-cinder']['solidfire_mvip'];
      "${section}/sf_api_port":                              value => $::fuel_settings['fuel-plugin-solidfire-cinder']['solidfire_api_port'];
      "${section}/sf_emulate_512":                           value => $::fuel_settings['fuel-plugin-solidfire-cinder']['solidifre_emulate_512'];
      "${section}/sf_allow_template_caching":                value => $::fuel_settings['fuel-plugin-solidfire-cinder']['solidfire_enable_image_caching'];
      "${section}/sf_template_account_name":                 value => $::fuel_settings['fuel-plugin-solidfire-cinder']['solidfire_image_cache_account'];
      "${section}/sf_account_prefix":                        value => $::fuel_settings['fuel-plugin-solidfire-cinder']['solidfire_account_prefix'];
    }

}
