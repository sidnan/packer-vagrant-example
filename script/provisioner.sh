#!/bin/bash -eux

# PROVISIONER and PROVISIONER_VERSION variables should be set inside of
# Packer's template:
#
# Valid values for $PROVISIONER are:
#   'provisionerless' -- build a box without a provisioner
#   'chef'            -- build a box with the Chef provisioner
#   'salt'            -- build a box with the Salt provisioner
#   'puppet'          -- build a box with the Puppet provisioner
#
# When $PROVISIONER != 'provisionerless' valid options for
# $PROVISIONER_VERSION are:
#   'x.y.z'           -- build a box with version x.y.z of the Chef provisioner
#   'x.y'             -- build a box with version x.y of the Salt provisioner
#   'latest'          -- build a box with the latest version of the provisioner
#
# Assume that PROVISIONER environment variable is set inside of Packer's
# template.
#
# Set PROVISIONER_VERSION to 'latest' if unset because it can be problematic
# to set variables in pairs with Packer (and Packer does not support
# multi-value variables).
PROVISIONER_VERSION=${PROVISIONER_VERSION:-latest}

#
# Provisioner installs.
#

install_chef()
{
    echo "==> Installing Chef provisioner"
    if [[ ${PROVISIONER_VERSION} == 'latest' ]]; then
        echo "Installing latest Chef version"
        curl -L https://www.opscode.com/chef/install.sh | sh
    else
        echo "Installing Chef version ${PROVISIONER_VERSION}"
        curl -L https://www.opscode.com/chef/install.sh | sh -s -- -v $PROVISIONER_VERSION
    fi

    if [[ ${PROVISIONER_SET_PATH:-} == 'true' ]]; then
        echo "Automatically setting vagrant PATH to Chef Client"
        echo 'export PATH="/opt/chef/embedded/bin:$PATH"' >> /home/vagrant/.bash_profile
        # Handy to have these packages install for native extension compiles
        apt-get update
        apt-get install -y libxslt-dev libxml2-dev
    fi
}

install_puppet()
{
    echo "==> Installing Puppet provisioner"
    . /etc/lsb-release

    DEB_NAME=puppetlabs-release-${DISTRIB_CODENAME}.deb
    wget http://apt.puppetlabs.com/${DEB_NAME}
    dpkg -i ${DEB_NAME}
    apt-get update
    apt-get install -y puppet facter
    rm -f ${DEB_NAME}
}

#
# Main script
#

case "${PROVISIONER}" in
  'chef')
    install_chef
    ;;

  'puppet')
    install_puppet
    ;;

  *)
    echo "==> Building box without a provisioner"
    ;;
esac