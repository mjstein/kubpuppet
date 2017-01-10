    class {'kubernetes::master':
      master_name      => '172.31.1.1', #can be hostname if dns setup
      minion_name      => '172.31.1.2', #can be hostname if dns setup
      master_is_minion =>  true,
    }

    class {'kubernetes::minion':
      master_name => '172.31.1.1', #can be hostname if dns setup
      minion_name => '172.31.1.1', #can be hostname if dns setup
    }
    contain 'kubernetes'
