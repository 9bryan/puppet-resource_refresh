#resource_refresh defined type
define resource_refresh (
  String $logfile,
  String $chaos_string,
  String $resource_name = $title,
  String $resource_type = 'Service',
){
  $resource_refresh_home   = '/opt/resource_refresh'
  $watch_file              = "${resource_refresh_home}/${title}-watch.txt"
  $resource_refresh_script = "${resource_refresh_home}/${title}-resource_refresh.sh"
  $_resource_type          = Resource[capitalize($resource_type)]

  File {
    owner => 'root',
    group => 'root',
  }

  #directory for this instance
  file { $resource_refresh_home:
    ensure => directory,
    mode   => '0550',
  }

  #If this file gets changed, restart the target resource
  file { $watch_file:
    ensure  => file,
    mode    => '0550',
    content => '',
    notify  => [$_resource_type[$resource_name],Service[$resource_refresh_script]],
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
    require => [File[$resource_refresh_script],[$_resource_type[$resource_name]]],
  }

}
