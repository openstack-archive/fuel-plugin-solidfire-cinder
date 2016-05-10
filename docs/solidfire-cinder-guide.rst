**********************************************************************
Guide to the SolidFire Cinder Plugin version 1.1-1.1.1-1 for Fuel 7.0
**********************************************************************

This document provides instructions for installing, configuring and using
SolidFire Cinder plugin for Fuel.

Key terms, acronyms and abbreviations
=====================================

MVIP
    Management Virtual IP (MVIP) is the IP address (or hostname) of
    the management interface to the SolidFire cluster

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
Fuel                         7.0

============================================

Prerequisites
--------------

* The SolidFire cluster should be configured and on the network prior to starting
  Cinder with the SolidFire configuration in place.

* Cinder relies on the open-iscsi package to preform many functions such as image
  to volume. This plugin requires (and installs) the open-iscsi package, so it must
  be avaliable in one of the repositories avaliable Fuel.

* See the `Mirantis, SolidFire joint reference architecture <https://content.mirantis.com/rs/451-RBY-185/images/SolidfireMirantisUnlockedReferenceArchitecture-4-25-2016.pdf>`_.

Limitations
-----------

* Fuel does not support multiple storage backends in Cinder,
  therefore the SolidFire Cinder Fuel plugin also does not support multiple backends.

* The SolidFire Cinder Fuel plugin does however provide the ability to
  create a configuration file stanza such that when multi-backend support
  is added to Fuel the stanza is correct. By selecting the checkbox (selected by default)
  'Multibackend Enabled' the stanza is added and the enabled_backends line is added to
  the 'default' section of the configuration file.

============================================

Installation Guide
==================


SolidFire Cinder plugin installation
------------------------------------

#. Download the plugin from
   `Fuel Plugins Catalog <https://www.mirantis.com/products/openstack-drivers-and-plugins/fuel-plugins/>`_.

#. Copy the plugin to an already installed Fuel Master node. If you do not
   have the Fuel Master node yet, follow the instructions from the
   official Mirantis OpenStack documentation:

   ::

      # scp fuel-plugin-solidfire-cinder-1.1-1.1.1-1.noarch.rpm \
          root@:<the_Fuel_Master_node_IP>:/tmp

#. Log into the Fuel Master node and install the plugin:

   ::

        # cd /tmp
        # fuel plugins --install /tmp/fuel-plugin-solidfire-cinder-1.1-1.1.1-1.noarch.rpm
        ...
        # fuel plugins list
        id | name                         | version | package_version
        ---|------------------------------|---------|----------------
        1  | fuel-plugin-solidfire-cinder | 1.1.1   | 2.0.0

SolidFire Cinder plugin configuration
-------------------------------------

#. After plugin is installed, create a new OpenStack environment following
   `the instructions <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#create-a-new-openstack-environment>`_.

#. Configure your environment following
   `the official Mirantis OpenStack documentation <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#configure-your-environment>`_.

#. Open the *Settings tab* of the Fuel web UI and scroll down the page and select
   'Fuel plugin to enable SolidFire driver in Cinder.' on the left.

#. Select the Fuel plugin checkbox to enable SolidFire Cinder plugin for Fuel:

      .. image:: figures/cinder-solidfire-plugin-1.1.0.png
         :width: 100%

#. The default configuration is that the SolidFire configuration stanza is a self contained stanza
   within the Cinder config file. In addition the enabled_backends directive is placed in the 'default'
   section to enable the SolidFire Stanza. This option allows for multiple backends to be configured and
   configures Cinder to place the proper routing information into the database.

#. If you would like the SolidFire configuration in the 'default' section of the configuration file
   (not recommended) uncheck the 'Multibackend Enabled' box. In this case, Cinder does not place routing
   information in the database, and if in the future multibackends are required, all rows in the database
   need to have routing information added using the cinder-manage tool.

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

#. 'Emulate 512 block size' will cause the driver to create volumes with 512 byte blocks enabled.  Otherwise
   4096 byte blocksize will be used.

#. 'SF account prefix' will prefix all accounts on the SolidFire cluster with the defined prefix. The
   prefix is useful (but not required) when multiple OpenStack instances access the same SolidFire cluster
   such that each instance can quickly identify accounts that belong to that instance. NOTE: Accounts
   on SolidFire are named using the Project/Tenant ID, optionally prefixed as defined here.

#. Once configuration is done, you can run
   `network verification <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#verify-networks>`_ check and `deploy the environment <https://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#deploy-changes>`_.


User Guide
==========

Once the OpenStack instance is deployed by Fuel, the SolidFire plugin provides no
user configurable or maintainable options.

The SolidFire driver (once configured by Fuel) will output all logs into the
cinder-volume process log file with the 'solidfire' title.

Known issues
============

Due to Fuels lack of support for multiple cinder backends, only a single storage vendor backend may be automatically
configure within Fuel at this time. If you need to support multiple vendors, hand editing of the cinder.conf is required.

Release Notes
=============

* Version 1.0.1 supports Fuel 6.x.

* Version 1.1.0 supports Fuel 7.x.

* Version 01.001.1 adds automated install of the open-iscsi package which is required by SolidFire, but not installed
  by Fuel if Ceph is selected in the starting wizzard. Supports Fuel 7.x.


Troubleshooting
===============

All SolidFire messages are output into the Cinder-volume log file. Search for 'solidfire'.

Appendix
========

`The SolidFire driver documentation <http://docs.openstack.org/kilo/config-reference/content/solidfire-volume-driver.html>`_
contains complete information on all SolidFire driver options.
