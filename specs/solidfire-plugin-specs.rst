
 This work is licensed under the Apache License, Version 2.0.

 http://www.apache.org/licenses/LICENSE-2.0

==================================================
Fuel plugin for SolidFire clusters as a Cinder backend
==================================================

SolidFire plugin for Fuel extends Mirantis OpenStack functionality by adding
support for SolidFire clusters in Cinder using iSCSI protocol.
It replaces Cinder LVM driver which is the default volume backend that uses
local volumes managed by LVM.

Problem description
===================

Currently, Fuel has no support for SolidFire clusters as block storage for
OpenStack environments. Solidfire plugin aims to provide support for it.

Proposed change
===============

Implement a Fuel plugin that will configure the SolidFire driver for
Cinder on all Controller nodes. Cinder volume service will be managed
by Pacemaker/Corosync to provide HA. Having all Cinder services run
on controllers no additional Cinder node is required in environment.

Alternatives
------------

It might have been implemented as part of Fuel core but we decided to make it
as a plugin for several reasons:

* This isn't something that all operators may want to deploy.
* Any new additional functionality makes the project's testing more difficult,
  which is an additional risk for the Fuel release.

Data model impact
-----------------

None

REST API impact
---------------

None

Upgrade impact
--------------

None

Security impact
---------------

None

Notifications impact
--------------------

None

Other end user impact
---------------------

None

Performance Impact
------------------

The SolidFire storage clusters provide high performance block storage for 
OpenStack envirnments, and therefore enabling the SolidFire driver in OpenStack
will greatly improve peformance of OpenStack. 

Other deployer impact
---------------------

The deployer should configure the IP addresses on the SolidFire array before 
they deloy the Fuel Plugin to the controllers.  If not, the Cinder-volume service
will need to be restarted once the SolidFire cluster is configured

Developer impact
----------------

None

Implementation
==============

The plugin generates the approriate cinder.conf stanzas to enable the SolidFire
cluster within OpenStack. There are NO other packages required, the SolidFire driver
which is included in the OpenStack distribution is all that is necessary. 

Plugin has two tasks. Each task per role. They are run in the following order:

* The first task installs and configures cinder-volume on Primary Controller.
* The second task installs and configures cinder-volume on Controller nodes.

Cinder-volume service is installed on all Controller nodes and is managed by
Pacemaker. It runs in active/passive mode where only one instance is active.
All instances of cinder-volume have the same “host” parameter in cinder.conf
file. This is required to achieve ability to manage all volumes in the
environment by any cinder-volume instance.

Assignee(s)
-----------

| Edward Balduf <ed.balduf@solidfire.com>
| John Griffith <john.griffith@solidfire.com>

Work Items
----------

* Implement the Fuel plugin.
* Implement the Puppet manifests.
* Testing.
* Write the documentation.

Dependencies
============

* Fuel 6.1 and higher.

Testing
=======

* Prepare a test plan.
* Test the plugin by deploying environments with all Fuel deployment modes.

Documentation Impact
====================

* Deployment Guide (how to install the storage backends, how to prepare an
  environment for installation, how to install the plugin, how to deploy an
  OpenStack environment with the plugin).
* User Guide (which features the plugin provides, how to use them in the
  deployed OpenStack environment).
* Test Plan.
* Test Report.

