# Rapid IdP Migrate

```
$ cd rapid-idp-migrate
$ ./rapid-idp-migrate --help
```

To securely upload your configuration to Australian Access Federation servers

```
$ ./rapid-idp-migrate --upload
```

### Manual download
You should only need this if you don't want to update your installer.
```
$ cd ~ # (or another working directory that is NOT the git repo)
$ curl -O https://raw.githubusercontent.com/ausaccessfed/shibboleth-idp-installer/master/rapid-idp-migrate/rapid-idp-migrate
$ chmod +x rapid-idp-migrate
$ ./rapid-idp-migrate --help
```
