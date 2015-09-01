exec {"update Apache Server":
	command => "/bin/yum update -y httpd"
}

package {"httpd":
	ensure => installed,
	require => Exec["update Apache Server"]
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
