***************************************************************
Guide to the SolidFire Cinder Plugin version 3.0.0 for Fuel 9.x
***************************************************************

This document provides instructions for installing, configuring and using
SolidFire Cinder plugin for Fuel.

Key terms, acronyms and abbreviations
=====================================

MVIP
    Management Virtual IP (MVIP) is the IP address (or hostname) of
    the management interface to the SolidFire cluster

SVIP
    Storage Virtual IP (SVIP) is the IP address (or hostname) of the
    storage interface of the SolidFire cluster. SolidFire supports
    multiple SVIPs on separate VLANs.

Cluster Admin account
    The Cluster Admin account on a SolidFire cluster is the account by
    which you administer the SolidFire cluster.

SolidFire accounts
    SolidFire accounts are automatically created by the SolidFire
    OpenStack driver as needed based on the Project ID. These accounts
    manage the CHAP authentication for the volumes allocated by that
    project. No configuration is needed for these accounts.

SolidFire Cinder
================

The SolidFire Cinder Fuel plugin provides an automated method
to insert the necessary lines into the cinder.conf file. The plugin
extends the Fuel GUI to provide the necessary entry locations for the
information for the configuration file.

Please see the
`SolidFire OpenStack Configuration Guide <http://www.solidfire.com/solutions/cloud-orchestration/openstack/>`_
for complete details.

License
-------

=======================   ==================
Component                  License type
=======================   ==================
No Components are present

============================================

Requirements
------------

=======================   ==================
Requirement                 Version/Comment
=======================   ==================
Fuel                              9.0

============================================

Prerequisites
--------------

* The SolidFire cluster should be configured and on the network prior to starting
  Cinder with the SolidFire configuration in place.

* Cinder relies on the open-iscsi package to preform many functions such as image
  to volume. This plugin requires (and installs) the open-iscsi package, so it must
  be avaliable in one of the repositories avaliable to Fuel.

* See the `Mirantis, SolidFire joint reference architecture <https://content.mirantis.com/rs/451-RBY-185/images/SolidfireMirantisUnlockedReferenceArchitecture-4-25-2016.pdf>`_.

Limitations
-----------

* The SolidFire Cinder Fuel plugin no longer supports a single backend in the
  DEFAULT section. The option has been removed from the GUI for multiple
  backends and the plugin will always assume multiple backends.

============================================

Installation Guide
==================


SolidFire Cinder plugin installation
------------------------------------

#. Download the plugin from
   `Fuel Plugins Catalog <https://www.mirantis.com/products/openstack-drivers-and-plugins/fuel-plugins/>`_.
   or clone this repository, install the fuel plugin builder with the
   following command

   ::

     pip install fuel-plugin-builder

   and then build the plugin using the following command:

   ::

     cd fuel-plugin-solidfire-cinder; fpb --build ./

#. Copy the plugin to an already installed Fuel Master node. If you do not
   have the Fuel Master node yet, follow the instructions from the
   official Mirantis OpenStack documentation:

   ::

      # scp cinder_solidfire-3.0-3.0.0-1.noarch.rpm \
          root@:<the_Fuel_Master_node_IP>:/tmp

#. Log into the Fuel Master node and install the plugin:

   ::

        # cd /tmp
        # fuel plugins --install /tmp/cinder_solidfire-3.0-3.0.0-1.noarch.rpm
        ...
        # fuel plugins list
        id | name             | version | package_version | releases
        ---+------------------+---------+-----------------+--------------------
        1  | cinder_netapp    | 5.0.0   | 4.0.0           | ubuntu (mitaka-9.0)

SolidFire Cinder plugin configuration
-------------------------------------

#. After plugin is installed, create a new OpenStack environment following
   `the instructions <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/create-environment/start-create-env.html>`_.

#. Configure your environment following
   `the official OpenStack documentation <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment.html>`_.

#. Open the *Storage tab* of the Fuel web UI and scroll down the page to
   'Fuel plugin for SolidFire in Cinder.'

#. Select the Fuel plugin checkbox to enable SolidFire Cinder plugin for Fuel:

      .. image:: figures/cinder-solidfire-plugin-3.0.0.png
         :width: 100%

#. The default configuration is that the SolidFire configuration stanza is a self contained stanza
   within the Cinder config file. In addition the enabled_backends directive is placed in the 'default'
   section to enable the SolidFire Stanza. This option allows for multiple backends to be configured and
   configures Cinder to place the proper routing information into the database.

#. Enter the Cluster Admin account information (account and password) and the IP address
   of the Management Virtual IP (MVIP) of the SolidFire Cluster.

#. It is recommended to select the defaults for all other SolidFire options, but explanations
   of each field are below.

#. 'Cluster endpoint port' defines the port number to communicate with the SolidFire API on. Generally
   this is not changed unless a HTTPs proxy is used or the port is otherwise changed.

#. 'Enable Caching' and 'Template Account' allow the SolidFire cluster to cache Glance images on the
   SolidFire cluster for all tenants. The template account will be automatically created on the SolidFire
   cluster and the cached images will be contained within this account.  The account will be prefixed with
   the 'SF account prefix' if defined.

#. 'SF account prefix' will prefix all accounts on the SolidFire cluster with the defined prefix. The
   prefix is useful (but not required) when multiple OpenStack instances access the same SolidFire cluster
   such that each instance can quickly identify accounts that belong to that instance. NOTE: Accounts
   on SolidFire are named using the Project/Tenant ID, optionally prefixed as defined here.

#. 'SF volume prefix' will cause all volumes on teh SolidFire cluster to be prefixed with with the
   configured characters. This is useful and recommended when multiple OpenStack instances are
   utilizing the same SolidFire cluster.  This field is pre-populated with the default value of 'UUID-'.

#. Once configuration is done, you can run
   `network verification <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/configure-environment/verify-networks.html>`_
   check and `deploy the environment <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-user-guide/deploy-environment.html>`_.

User Guide
==========

Once the OpenStack instance is deployed by Fuel, the SolidFire plugin provides no
user configurable or maintainable options.

The SolidFire driver (once configured by Fuel) will output all logs into the
cinder-volume process log file with the 'solidfire' title.

Known issues
============

For Mitaka (Fuel 9.0) the following change is required to be in place
https://review.openstack.org/#/c/347066/ in file
/etc/puppet/mitaka-9.0/modules/cinder/manifests/backend/solidfire.pp on the
fuel master.

Release Notes
=============

* Version 1.0.1 supports Fuel 6.x.

* Version 1.1.0 supports Fuel 7.x.

* Version 1.1.1 adds automated install of the open-iscsi package which is required by SolidFire, but not installed
  by Fuel if Ceph is selected in the starting wizzard. Supports Fuel 7.x.

* Version 2.0.0 refactors the code to support Fuel 8.0

* Version 3.0.0 refactors the code to support Fuel 9.0


Troubleshooting
===============

All SolidFire messages are output into the Cinder-volume log file. Search for 'solidfire'.

Appendix
========

`The SolidFire driver documentation
<http://docs.openstack.org/mitaka/config-reference/block-storage/drivers/solidfire-volume-driver.html>`_
contains complete information on all SolidFire driver options.
