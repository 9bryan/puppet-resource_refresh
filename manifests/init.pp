#service_charm defined type

define service_charm (
  $logfile,
  $chaos_string,
  $service = $title,
){
  $service_charm_base   = '/opt/service_charm'
  $service_charm_home   = "${service_charm_base}/${title}"
  $watch_file           = "${service_charm_home}/${title}-watch.txt"
  $service_charm_script = "${service_charm_home}/${title}-service_charm.sh"

  #If service_charm_base directory doesnt exist, create it
  if defined(File[$service_charm_base])==false {
    file { $service_charm_base:
      ensure => directory,
      mode   => '0550',
      before => File[$service_charm_home],
    }
  }

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
    content => '0',
    notify  => Service[$service],
    require => File[$service_charm_home],
  }

  file { $service_charm_script:
    ensure  => file,
    mode    => '0550',
    content => template('service_charm/service_charm.sh.erb'),
    require => File[$service_charm_home],
  }

}
