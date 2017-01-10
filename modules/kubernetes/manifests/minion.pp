class kubernetes::minion($master_name=undef, $minion_name=undef, $alternate_flannel_interface_bind = false){
  validate_string($master_name,$minion_name)
  if not defined(Class['kubernetes']){
    class {'kubernetes':
      master_name =>  $master_name,
      minion_name =>  $minion_name,
    }
  }
  kubernetes::core{'minion_core':
    master_name =>  $master_name,
    minion_name =>  $minion_name,
  }->
  file{'/etc/kubernetes/kubelet':
    content => template('kubernetes/kubelet.erb')
  }~>
  service{['kube-proxy','kubelet', 'flanneld']:
    ensure => running,
    enable => true,
  }~>
  service{'docker':
    ensure => running,
    enable => true,
  }

}

