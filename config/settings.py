# Copyright (C) 2014 Universidad Politecnica de Madrid
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

KEYROCK_VERSION = '4.4.1'

IDM_ROOT = './'
KEYSTONE_ROOT = IDM_ROOT + 'keystone/'
HORIZON_ROOT = IDM_ROOT + 'horizon/'

# Development settings
KEYSTONE_DEV_DATABASE = 'keystone.db'
HORIZON_DEV_ADDRESS = '0.0.0.0:8000'

# TODO(garcianavalon) sync this with the extension,
# see https://trello.com/c/rTsUMnjw
INTERNAL_ROLES = {
    'provider': [0, 1, 2, 3, 4, 5],
    'purchaser': [2],
}
INTERNAL_PERMISSIONS = [
    'Manage the application',
    'Manage roles',
    'Get and assign all public application roles',
    'Manage Authorizations',
    'Get and assign only public owned roles',
    'Get and assign all internal application roles',
]

# TODO(garcianavalon) sync with local_settings.py
KEYSTONE_DEFAULT_DOMAIN = 'default'

IDM_USER_CREDENTIALS = {
    'username': 'idm',
    'password': 'idm',
    'project': 'idm',
}

KEYSTONE_ADMIN_PORT = '35357'
KEYSTONE_PUBLIC_PORT = '5000'
KEYSTONE_ADMIN_TOKEN = 'ADMIN'

KEYSTONE_PUBLIC_ADDRESS = '127.0.0.1'
KEYSTONE_ADMIN_ADDRESS = '127.0.0.1'
KEYSTONE_INTERNAL_ADDRESS = '127.0.0.1'

SERVICE_CATALOG = [
  {
    "endpoints": [
      {
        "region": "Spain2",
        "adminURL": "http://{url}:{port}/v3/".format(
          url=KEYSTONE_ADMIN_ADDRESS, port=KEYSTONE_ADMIN_PORT),
        "internalURL": "http://{url}:{port}/v3/".format(
          url=KEYSTONE_INTERNAL_ADDRESS, port=KEYSTONE_ADMIN_PORT),
        "publicURL": "http://{url}:{port}/v3/".format(
          url=KEYSTONE_PUBLIC_ADDRESS, port=KEYSTONE_PUBLIC_PORT)
      }
    ],
    "type": "identity",
    "name": "keystone"
  }
]

UBUNTU_DEPENDENCIES = {
    'horizon': [
        'python-dev',
        'python-virtualenv',
        'libssl-dev',
        'libffi-dev',
        'libjpeg8-dev',
    ],
    'keystone': [
        'python-dev',
        'python-virtualenv',
        'libxml2-dev',
        'libxslt1-dev',
        'libsasl2-dev',
        'libssl-dev',
        'libldap2-dev',
        'libffi-dev',
        'libsqlite3-dev',
        'libmysqlclient-dev',
        'python-mysqldb',
    ],
}

# For test_data
FIWARE_DEFAULT_APPS = {
    'Cloud' : ['Member'],
    'Mashup': [],
    'Store':[],
}


# --- ADDED AUTOMATICALLY --- 
INTERNAL_ROLES_IDS = {
	'provider': '1528c560e6214e10aedb3c081d067f0e',
	'purchaser': '703d63d89a4c4b50a93881954b9f55a0'
}
