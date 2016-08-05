define plugin_cinder_solidfire::enable_backend () {

  notice("Enabling backend: ${backend_name}")

  $config_file = '/etc/cinder/cinder.conf'

  ini_subsetting {"enable_${name}_backend":
    ensure               => present,
    section              => 'DEFAULT',
    key_val_separator    => '=',
    path                 => $config_file,
    setting              => 'enabled_backends',
    subsetting           => $name,
    subsetting_separator => ',',
  }
}
