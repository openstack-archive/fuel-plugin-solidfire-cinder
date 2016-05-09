notice('MODULAR: solidfire-hiera-override')

$cinder_solidfire = hiera_hash('cinder_solidfire', {})

$hiera_dir    = '/etc/hiera/plugins'
$plugin_yaml  = 'cinder_solidfire.yaml'
$plugin_name  = 'cinder_solidfire'

$content = inline_template('
storage_hash:
  volume_backend_names:
    solidfire: cinder_solidfire
')

file { $hiera_dir:
  ensure => directory,
}

file { "${hiera_dir}/${plugin_yaml}":
  ensure  => file,
  content => $content,
}
