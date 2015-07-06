class tada::valley::service (
  $dqlevel  = hiera('dq_loglevel', 'WARNING'),
  $qname    = hiera('qname'),
  $dqlog    = hiera('dqlog'),
  ) {

  Python::Requirements[ '/etc/tada/requirements.txt'] ->
  exec { 'dqsvcpop':
    command     => "/usr/bin/dqsvcpop --loglevel ${dqlevel} --queue ${qname} > ${dqlog} 2>&1 &",
    cwd         => '/home/tada',
    environment => 'HOME=/home/tada',
    user        => 'tada',
    umask       => '000',
    creates     => '/var/run/tada/dqsvcpop.pid',
    #! refreshonly => true,
    require     => [File['/var/run/tada'],
                    Class['redis'],
                    Exec['iinit'],
                    Python::Requirements[ '/etc/tada/requirements.txt'],
                    ],
    subscribe   => [File['/etc/tada/tada.conf'],
                    Exec['iinit'],
                    ],
  }
  
}

