import os
from onvif2 import ONVIFCamera
from datetime import datetime, timezone

# utc_now = datetime.now()
# print(utc_now.strftime("%m/%d/%Y, %H:%M:%S"))

utc_dt = datetime.now(timezone.utc)
print("Starting process at Local time {}".format(utc_dt.astimezone().isoformat()))

# camera_ip = "your camera ip"
# camera_port = "your camera port, default is 80"
# wsdl_path = "path to wsdl folder"
now = datetime.utcnow()
CAMERA_USERNAME = os.environ['CAMERA_USERNAME']
CAMERA_PASSWORD = os.environ['CAMERA_PASSWORD']
TZ = os.environ.get('TZ_IN_ANOTHER_FORMAT', 'GMT+5:30:00')
CAMERA_IPS = os.environ.get('CAMERA_IPS', '10.100.20.192,10.100.20.195,10.100.20.196,10.100.20.197,10.100.20.198,10.100.20.199')
camera_ips = CAMERA_IPS.split(",")

# Connect to camera

def get_cam(ip: str):
  return ONVIFCamera(ip, 80, CAMERA_USERNAME, CAMERA_PASSWORD, wsdl_dir='/scripts/wsdl')

def get_time_params():
  mycam = get_cam(camera_ips[0])

  # Get system date and time
  time_params = mycam.devicemgmt.create_type('SetSystemDateAndTime')
  time_params.DateTimeType = 'Manual'
  time_params.DaylightSavings = True

  tz = {'TZ':TZ}
  time_params.TimeZone = tz

  Data = {'Year':now.year,'Month':now.month,'Day':now.day}
  Time = {'Hour':now.hour,'Minute':now.minute,'Second':now.second}
  time_data = {'Date':Data,'Time':Time}

  time_params.UTCDateTime = time_data
  return time_params

def set_time(ip: str, time_params):
  mycam = get_cam(ip)
  mycam.devicemgmt.SetSystemDateAndTime(time_params)
  # print(mycam.devicemgmt.GetSystemDateAndTime())

# for i in camera_ips[1:]: #Skip first element
time_params=get_time_params()
print(time_params)
for ip in camera_ips: #Skip first element
  print(ip)
  set_time(ip, time_params)
