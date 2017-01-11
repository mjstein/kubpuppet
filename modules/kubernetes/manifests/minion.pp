class kubernetes::minion($master_name=undef, $minion_name=undef, $alternate_flannel_interface_bind = false, $master_is_minion = false){
  validate_string($master_name,$minion_name)
  unless defined(Class['kubernetes']){
    class {'kubernetes':
      master_name => $master_name,
      minion_name => $minion_name,
      before      =>  Kubernetes::Core['minion_core']
    }
  }
  unless defined(Kubernetes::Core['master_core']){
    kubernetes::core{'minion_core':
      master_name => $master_name,
      minion_name => $minion_name,
      before      =>  File['/etc/kubernetes/kubelet']
    }
  }
  file{'/etc/kubernetes/kubelet':
    content => template('kubernetes/kubelet.erb'),
    require => Package['kubernetes'],
    notify  =>  Service['kubelet'],
  }
  service{['kube-proxy','kubelet']:
    ensure  => running,
    enable  => true,
    require =>  Package['kubernetes']
  }

}

