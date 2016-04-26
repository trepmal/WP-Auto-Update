Update core (and db), plugins, and themes, logging status to syslog. Ideal for running on a cronjob

Example of syslog
```
Apr 26 04:07:56 vvv vagrant: [WPAutoUpdate] Local WordPress Dev | http://local.wordpress.dev
Apr 26 04:08:27 vvv vagrant: [WPAutoUpdate] Core update: WordPress updated successfully to 4.5
Apr 26 04:08:28 vvv vagrant: [WPAutoUpdate] DB update: WordPress database already at latest db version 36686
Apr 26 04:08:30 vvv vagrant: [WPAutoUpdate] Plugin updates: Akismet, Yoast SEO
Apr 26 04:08:34 vvv vagrant: [WPAutoUpdate] Theme updates: Twenty Fifteen, Twenty Fourteen, Twenty Sixteen, Twenty Twelve
```

Specify path as first argument passed to script  
`./auto-update.sh /path/to/wp`

