# Rapid IdP Migrate

```
$ cd rapid-idp-migrate
$ ./rapid-idp-migrate archive --help
```

To securely upload your configuration to Australian Access Federation servers

```
$ ./rapid-idp-migrate archive --upload
```

### Manual download
You should only need this if you don't want to update your `shibboleth-idp-installer` repo.
```
$ cd ~ # (or another working directory that is NOT the git repo)
$ curl -O https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/master/rapid-idp-migrate/rapid-idp-migrate
$ chmod +x rapid-idp-migrate
$ ./rapid-idp-migrate --help
```

### Advanced usage
- If there's no running Shibboleth IdP, manually specify a version:
  ```
  $ ./rapid-idp-migrate archive --shibboleth-version=3.0.0
  ```
- If not using Jetty, manually specify a database connection and use a mock Jetty directory:
  
  You will be prompted for Database password.
  ```
  $ ./rapid-idp-migrate archive --database-hostname=127.0.0.1 --database-name=idp_db --database-username=idp_admin --jetty-base-directory=/opt/some/empty/dir/or/other/server/config/
  ```
- If you've created your own archive and need to securely send the file:
  ```
  $ ./rapid-idp-migrate custom-upload --entity-id=MY-ENTITY-ID --archive-path=/path/to/archive.tar.gz
  ```
- Filter out lines from files (defaults to lines with `password` or `Password`):

  This should only be used if AAF does not need sensitive credentials.
  ```
  $ ./rapid-idp-migrate archive --filter-lines
  ```
