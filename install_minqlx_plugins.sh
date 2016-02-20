#!/bin/bash

wget https://bootstrap.pypa.io/get-pip.py
python3.5 get-pip.py
rm get-pip.py
python3.5 -m easy_install pyzmq hiredis
python3.5 -m pip install -r minqlx-plugins/requirements.txt
