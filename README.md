# resource_refresh

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with resource_refresh](#setup)
    * [What resource_refresh affects](#what-resource_refresh-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with resource_refresh](#beginning-with-resource_refresh)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module lays down a script that will monitor a log file and bounce a service when a string is found.  This is a hack.  This not a monitoring solution.

This module is for the sysadmin that keeps getting calls because a service keeps crashing and he needs to have it automatically restart when it loses its brains.

## Module Description

If applicable, this section should have a brief description of the technology
the module integrates with and what that integration enables. This section
should answer the questions: "What does this module *do*?" and "Why would I use
it?"

If your module has a range of functionality (installation, configuration,
management, etc.) this is the time to mention it.

## Setup

### What resource_refresh affects

* A list of files, packages, services, or operations that the module will alter,
  impact, or execute on the system it's installed on.
* This is a great place to stick any warnings.
* Can be in list or paragraph form.

### Setup Requirements **OPTIONAL**

If your module requires anything extra before setting up (pluginsync enabled,
etc.), mention it here.

### Beginning with resource_refresh

The very basic steps needed for a user to get the module up and running.

If your most recent release breaks compatibility or requires particular steps
for upgrading, you may wish to include an additional section here: Upgrading
(For an example, see http://forge.puppetlabs.com/puppetlabs/firewall).

## Usage

After setting up your app, add the resource_refresh with the name of the service as the title and the logfile that you want to watch.  Chaos_string is the string in your logs that brings your service into an undesirable state.

~~~
  class { 'tomcat': }
  class { 'java': }
  tomcat::instance { 'test':
    source_url => 'http://mirror.symnds.com/software/Apache/tomcat/tomcat-8/v8.0.28/bin/apache-tomcat-8.0.28.tar.gz',
  }->
  tomcat::service { 'default': }

  resource_refresh { 'tomcat-default':
    logfile      => '/opt/apache-tomcat/logs/catalina.out',
    chaos_string => 'Error parsing HTTP request header',
  }
~~~

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Only tried with Centos 6.

Should work on anything with tail and egrep.

The service wont be restarted right away, it will only be restarted when puppet runs.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You may also add any additional sections you feel are
necessary or important to include here. Please use the `## ` header.
