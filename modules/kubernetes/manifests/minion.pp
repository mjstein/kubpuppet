class kubernetes::minion($master_name=undef, $minion_name=undef, $alternate_flannel_interface_bind = false){
  validate_string($master_name,$minion_name)
  unless defined(Class['kubernetes']){
    class {'kubernetes':
      master_name => $master_name,
      minion_name => $minion_name,
      before      =>  Kubernetes::Core['minion_core']
    }
  }
  kubernetes::core{'minion_core':
    master_name =>  $master_name,
    minion_name =>  $minion_name,
  }->
  file{'/etc/kubernetes/kubelet':
    content => template('kubernetes/kubelet.erb')
  }~>
  service{['kube-proxy','kubelet']:
    ensure => running,
    enable => true,
  }

}

