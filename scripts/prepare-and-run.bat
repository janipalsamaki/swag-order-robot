
echo environment dump when starting
set

py -m venv venv
call venv\Scripts\activate

python -m pip install --upgrade pip
pip install -r requirements.txt
webdrivermanager chrome

python -m robot -d output swag-order-robot.robot

call venv\Scripts\deactivate
