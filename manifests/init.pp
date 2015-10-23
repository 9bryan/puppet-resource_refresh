#service_charm defined type

define service_charm (
  $logfile,
  $chaos_string,
  $service = $title,
){
  $service_charm_home   = '/opt/service_charm'
  $watch_file           = "${service_charm_home}/${title}-watch.txt"
  $service_charm_script = "${service_charm_home}/${title}-service_charm.sh"

  File {
    owner => 'root',
    group => 'root',
  }

  #directory for this instance
  file { $service_charm_home:
    ensure => directory,
    mode   => '0550',
  }

  #If this file gets changed, restart the target service
  file { $watch_file:
    ensure  => file,
    mode    => '0550',
    content => '',
    notify  => [Service[$service],Service[$service_charm_script]],
    require => File[$service_charm_home],
  }

  file { $service_charm_script:
    ensure  => file,
    mode    => '0550',
    content => template('service_charm/service_charm.sh.erb'),
    require => File[$service_charm_home],
    notify  => Service[$service_charm_script],
  }

  service { $service_charm_script:
    ensure  => running,
    start   => $service_charm_script,
    status  => "ps -ef | grep ${logfile} | grep -v grep",
    stop    => "kill $(ps -ef | grep ${logfile} | grep -v grep | awk '{ print \$2 }')",
    restart => "kill $(ps -ef | grep ${logfile} | grep -v grep | awk '{ print \$2 }'); ${service_charm_script}",
    require => [File[$service_charm_script],[Service[$service]]],
  }

}
