fuel-plugin-solidfire-cinder
============

Plugin description
--------------

SolidFire plugin for Fuel extends Mirantis OpenStack functionality by
adding support for SolidFire all Flash block storage cluster.

The SolidFire cluster is an iSCSI block storage device used as a
Cinder backend.

Requirements
------------

| Requirement                                              | Version/Comment |
|----------------------------------------------------------|-----------------|
| Mirantis OpenStack compatibility                         | >= 6.1          |
| Access to SolidFire MVIP via cinder-volume node          |                 |
| Access to SolidFire SVIP via compute/cinder-volume nodes |                 |
| iSCSI initiator on all compute/cinder-volume nodes       |                 |

Limitations
-----------

Currently Fuel doesn't support multi-backend.

SolidFire configuration
---------------------

Before starting a deployment there are some things that you should verify:
1. Your SolidFire Cluster can route 10G Storage Network to all Compute nodes
   as well as the Cinder Control/Manager node.
2. Create an account on the SolidFire cluster to use as the OpenStack Administrator
   account (use the login/password for this account as san_login/password settings).
3. Obtain the MVIP address from the SolidFire cluster (uses as the san_ip)

SolidFire Cinder plugin installation
---------------------------

All of the needed code for using SolidFire in an OpenStack deployment is
included in the upstream OpenStack distribution.  There are no additional
libraries, software packages or licenses.

SolidFire plugin configuration
----------------------------
