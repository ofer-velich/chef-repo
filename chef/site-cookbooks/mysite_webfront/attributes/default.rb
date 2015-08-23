

default[:mysite_webfront][:packages] = [
	'libapache2-mod-auth-mysql' , 'libwww-perl', 'libcrypt-ssleay-perl', 'libswitch-perl', 
	'mysql-client' , 'python-pip', 'python-setuptools', 'python-magic', 'nodejs', 'npm',
	'redis-server', 'swfmill', 'libvorbis-dev', 'libtheora-dev', 'libspeex-dev', 'libopencore-amrnb-dev', 
	'libopencore-amrwb-dev', 'libmp3lame-dev', 'libass4'
]

default[:mysite_webfront][:s3][:packages] = [
	'libfaac0_1.28-0ubuntu2_amd64.deb',
	'logstash-forwarder_0.3.1_amd64.deb',
	'libfaac-dev_1.28-0ubuntu2_amd64.deb',
	'libopus_201303121243-git-1_amd64.deb',
	'libvpx_201303121234-git-1_amd64.deb',
	'ffmpeg_201303121409-git-1_amd64.deb',
	'Phantomjs2.0.1.deb',
	'project_conversion_temp_folders-1.0_amd64.deb'
]



