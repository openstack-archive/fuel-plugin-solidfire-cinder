notice('MODULAR: solidfire-hiera-override')

$cinder_solidfire = hiera_hash('cinder_solidfire', {})

$hiera_dir    = '/etc/hiera/plugins'
$plugin_yaml  = 'cinder_solidfire.yaml'
$plugin_name  = 'cinder_solidfire'

$content = inline_template('
storage:
  volume_backend_names:
    solidfire: solidfire
')

file { $hiera_dir:
  ensure => directory,
}

file { "${hiera_dir}/${plugin_yaml}":
  ensure  => file,
  content => $content,
}

# Workaround for bug 1598163
exec { 'patch_puppet_bug_1598163':
  path    => '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin',
  cwd     => '/etc/puppet/modules/osnailyfacter/manifests/globals',
  command => "sed -i \"s/hiera('storage/hiera_hash('storage/\" globals.pp",
  onlyif  => "grep \"hiera('storage\" globals.pp"
}
