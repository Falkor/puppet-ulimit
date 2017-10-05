#
# You can execute this manifest as follows in your vagrant box
#
#      sudo puppet apply -vt /vagrant/tests/rule.pp
#
node default {
  include ::ulimit

  # This will create the file '/etc/security/limits.d/80_slurm.conf' with the
  # following content:
  #
  # /etc/security/limits.d/80_slurm.conf
  # [...]
  # *       soft         memlock      unlimited
  # *       soft         stack        unlimited
  # *       hard         memlock      unlimited
  # *       hard         stack        unlimited
  #
  ::ulimit::rule{ 'slurm':
    ensure        => 'present',
    ulimit_domain => '*',
    ulimit_type   => [ 'soft', 'hard' ],
    ulimit_item   => [ 'memlock', 'stack' ],
    ulimit_value  => 'unlimited',
  }

  # Below statement should create '/etc/security/limits.d/50_slurm-nproc.conf'
  # with the following content:
  #
  # *       soft         nproc        10240
  # *       hard         nproc        10240
  #
  ::ulimit::rule{ 'slurm-nproc':
    ensure        => 'present',
    priority      => 50,
    ulimit_domain => '*',
    ulimit_type   => [ 'soft', 'hard' ],
    ulimit_item   => 'nproc',
    ulimit_value  => '10240',
  }

  # You can also pass the content yourself -- below statement will create
  # '/etc/security/limits.d/60_content.conf' with that content
  ::ulimit::rule{ 'content':
    ensure   => 'present',
    priority => 60,
    content  => template('ulimit/test.erb'),
  }

  # ... or pass directly the source file -- below statement will create
  # '/etc/security/limits.d/70_source.conf' with that content
  ::ulimit::rule{ 'source':
    ensure        => 'present',
    priority      => 70,
    source        => 'puppet:///modules/ulimit/test.conf',
  }

}