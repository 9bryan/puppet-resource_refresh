#resource_refresh defined type
define resource_refresh (
  $logfile,
  $chaos_string,
  $service = $title,
){
  $resource_refresh_home   = '/opt/resource_refresh'
  $watch_file              = "${resource_refresh_home}/${title}-watch.txt"
  $resource_refresh_script = "${resource_refresh_home}/${title}-resource_refresh.sh"

  File {
    owner => 'root',
    group => 'root',
  }

  #directory for this instance
  file { $resource_refresh_home:
    ensure => directory,
    mode   => '0550',
  }

  #If this file gets changed, restart the target service
  file { $watch_file:
    ensure  => file,
    mode    => '0550',
    content => '',
    notify  => [Service[$service],Service[$resource_refresh_script]],
    require => File[$resource_refresh_home],
  }

  file { $resource_refresh_script:
    ensure  => file,
    mode    => '0550',
    content => template('resource_refresh/resource_refresh.sh.erb'),
    require => File[$resource_refresh_home],
    notify  => Service[$resource_refresh_script],
  }

  service { $resource_refresh_script:
    ensure  => running,
    start   => $resource_refresh_script,
    status  => "ps -ef | grep ${logfile} | grep -v grep",
    stop    => "kill $(ps -ef | grep ${logfile} | grep -v grep | awk '{ print \$2 }')",
    restart => "kill $(ps -ef | grep ${logfile} | grep -v grep | awk '{ print \$2 }'); ${resource_refresh_script}",
    require => [File[$resource_refresh_script],[Service[$service]]],
  }

}
