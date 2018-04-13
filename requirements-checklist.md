---
---

# Requirements Checklist

You MUST NOT continue to installation until you've worked through the checklists below. Environmental preperation is critical to a successful outcome.

## Required Checklist

1. A **dedicated** CentOS 7 or Redhat 7 server (virtual or physical), with the following minimum specifications:

    1. 2 CPU
    2. 4GB RAM
    3. 10GB+ partition for OS

This server MUST NOT be used for any other purpose in the future.

#### Additional requirements for CentOS 7 servers

As **root** install [EPEL](https://fedoraproject.org/wiki/EPEL) with the following command

            $> yum -y install epel-release

#### Additional requirements for Redhat 7 servers

Redhat systems also require EPEL in order to continue and the above is one option you MAY use to achieve this.

In some commercial environments you may need to have the server enabled for these packages via Satellite.

In this case please speak to your system administrators and have this configured before continuing.

2. You MUST have SSH access to the server
3. You MUST be able to execute commands as `root` on the system without limitation
4. The server MUST be routable from the public internet with a static IP. Often this means configuring the IP on a local network interface directly but advanced environments may handle this differently.
5. The static IP MUST have a publicly resolvable DNS entry. Typically of the form `idp.example.edu`
6. The server MUST be able to communicate with the wider internet without blockage due to firewall rules. All publicly routable servers MUST be accessible for:

    | Port | Purpose |
    |------|---------|
    | 80   | Outbound HTTP connections |
    | 443  | Outbound HTTPS connections |

    Each of the following commands MUST succeed when run *on your server*:

      1. `curl http://example.edu`
      2. `curl https://example.edu`

7. The server MUST be accessible from the wider internet without blockage due to firewall rules for:

    | Port | Purpose |
    |------|---------|
    | 80   | Inbound HTTP connections used within SAML flows  |
    | 443  | Inbound HTTPS connections used within SAML flows  |
    | 8443 | Backchannel, client verified TLS connections, used within SAML flows |

9. Environmental data for your IdP

    1. A determination of the AAF federation you wish to register your IdP within, being test or production. AAF Support can assist you in determining this
    1. Organisation Name
    1. Organization base domain e.g. `example.edu`

## Optional Checklist

1. An account which can bind to and run queries against your corporate directory service. You'll require the following pieces of information from your directory administrator:

    1. IP Address / DNS entry for your LDAP server and connection port
    2. Base DN for user objects within your directory
    3. The Bind DN of the account you wish to connect to the directory with
    4. The password for the above account
    5. An LDAP filter attribute, often `uid`

If you:

* Don't have LDAP details available;
* Wish to use TLS connections; or
* Have an advanced deployment scenario for your directory infrastructure.

You'll need to undertake further customisation during the installation process when prompted. Each of these scenarios are outside of the installers scope.

## Next Step

Once you've finalised these checklists please continue to the [installation](installation.html) stage.
