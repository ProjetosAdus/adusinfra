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

package {"vsftpd":
	ensure => latest
}

service{"vsftpd":
	ensure => running,
	enable => true,
	hasstatus => true,
	hasrestart => true,
	require => Package["vsftpd"]
}
	

file {"/etc/hosts":
	ensure => file

}

File['/etc/hosts']{
	content => "192.168.33.30 informadusview.informadus"
}
