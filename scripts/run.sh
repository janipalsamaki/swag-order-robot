#!/bin/bash

. venv/bin/activate

python --version
python -c "import platform; print(platform.uname())"

python -m robot -d output swag-order-robot.robot
