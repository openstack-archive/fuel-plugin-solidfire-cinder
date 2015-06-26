#
# The spec is generated automatically by Fuel Plugin Builder tool
# https://github.com/stackforge/fuel-plugins
#
# RPM spec file for package fuel-plugin-solidfire-cinder-1.0
#
# Copyright (c) 2015, Apache License Version 2.0, John Griffith <john.griffith@solidfire.com>
#

Name:           fuel-plugin-solidfire-cinder-1.0
Version:        1.0.0
Url:            https://github.com/stackforge/fuel-plugins
Summary:        Fuel plugin to enable SolidFire driver in Cinder
License:        Apache License Version 2.0
Source0:        fuel-plugin-solidfire-cinder-1.0.fp
Vendor:         John Griffith <john.griffith@solidfire.com>
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
Group:          Development/Libraries
Release:        1
BuildArch:      noarch

%description
Enables the SolidFire driver in Cinder

%prep
rm -rf %{name}-%{version}
mkdir %{name}-%{version}

tar -vxf %{SOURCE0} -C %{name}-%{version}

%install
cd %{name}-%{version}
mkdir -p %{buildroot}/var/www/nailgun/plugins/
cp -r fuel-plugin-solidfire-cinder-1.0 %{buildroot}/var/www/nailgun/plugins/

%clean
rm -rf %{buildroot}

%files
/var/www/nailgun/plugins/fuel-plugin-solidfire-cinder-1.0
