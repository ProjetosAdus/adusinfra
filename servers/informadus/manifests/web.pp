
package {"httpd":
	ensure => latest
}

service {"httpd":
	ensure => running,
	enable => true,
	hasstatus => true,
	hasrestart => true,
	require => Package["httpd"]
}

package {"iptables":
	ensure => "purged"
}

exec {"get repository":
	command => "/usr/bin/rpm -iUvh http://ftp.astral.ro/mirrors/fedora/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm"
}

package {"proftpd":
	ensure => installed,
	require => Exec["get repository"]
}

service{"proftpd":
	ensure => running,
	enable => true,
	hasstatus => true,
	hasrestart => true,
	require => File["/etc/sysconfig/proftpd"]
}

file{"/etc/hosts":
	content => "192.168.33.30 informadusview.informadus"
}

file{"/etc/sysconfig/proftpd":
	content => "PROFTPD_OPTIONS='-DANONYMOUS_FTP'",
	require => Package["proftpd"]
}

file{"/etc/httpd/conf/httpd.conf":
	ensure => file,
	content => template("/vagrant/templates/httpd.conf"),
	require => File["/etc/sysconfig/proftpd"],
	notify => Service["httpd"]
}

exec{"grant all httpd":
	command => "/usr/bin/chmod 777 /var/ftp/uploads",
	require => Package["proftpd"]
}	
