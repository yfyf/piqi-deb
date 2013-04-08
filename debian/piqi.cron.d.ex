#
# Regular cron jobs for the piqi package
#
0 4	* * *	root	[ -x /usr/bin/piqi_maintenance ] && /usr/bin/piqi_maintenance
