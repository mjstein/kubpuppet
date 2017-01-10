
define kubernetes::core($master_name, $minion_name){

  package {['docker', 'docker-logrotate', 'kubernetes', 'etcd', 'flannel']:
    ensure => present,
  }~>

  file{'/etc/kubernetes/config':
    content => template('kubernetes/kub_config.erb')
  }~>
  file{'/etc/sysconfig/flanneld':
    content => template('kubernetes/flanneld.erb'),
  }~>
  service{'flanneld':
    ensure => running,
    enable => true,
  }~>
  service{'docker':
    ensure => running,
    enable => true,
  }
}
