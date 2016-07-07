---
---

# Notes on HA IdP from UQ

**Need to review and test before linking to the site**


----------
Anyway, we have a pair of VMs that run in different datacentres to provide the service (this is UQ's IdP on the testfed).
The service IP for idp2.uq.edu.au is handled by keepalive, under the control of keepalived.  We're running in an "active-standby" model, where the standby only receives traffic when the active is down.

Each box has its own mysql, which keeps the usual sorts of stuff (auEduPersonSharedToken and eduPersonTargetedId values).
Session-related stuff like the session.StorageService, replayCache.StorageService and artifact.StorageService are pointed towards memcached, which runs on both boxes.

The host that normally holds the keepalived IP runs a small health check script, currently every minute but I may make that more frequent in production.
The script checks the process list to make sure the required components are running (mysqld, httpd and a tomcat or jetty).  It also requests the https://localhost/idp/status page and makes sure that comes back in a timely manner, containing some expected text.  We use a rather conservative/brute force approach that runs the health check from cron, and if it fails it will stop keepalived (if it is running).  If the health check succeeds and keepalived is absent, it will start keepalived.  I understand that keepalived can perform health checks itself, but when I last looked at that in detail (~2 yr ago) I could not make it work and instead opted for the systemctl stop keepalived hammer.  That's carried over in to this iteration.

Syncing the mysqld.  Clustering the mysql seemed too involved for this use case, so we have two standalone mysqlds.  Every 30 mins, the "normally active" node's mysqld is dumped.  If this has changed significantly since the last dump, the new one is saved in something like a "latest dump" file.  Also every 30 mins, the "normally inactive" host downloads that latest dump file via ssh.  If it's changed, it will restore the new data in to its mysql (unless it's the active node, in which case it backs off that process).

Hope this helps!

Happy to talk further if you'd like.


Cheers,
Roy
