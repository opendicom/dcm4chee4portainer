# Run dcm4chee on Debian

Start the PACS: sudo /etc/init.d/dcm4chee start

CLI for PACS management (restart PACS): sudo /etc/init.d/dcm4chee {status|start|stop|restart}

CLI for current log: tail -f /var/lib/dcm4chee/server/default/log/server.log
