from datetime import date, datetime, timedelta, timezone
import os
import argparse

import httpx

# utc_now = datetime.now()
# print(utc_now.strftime("%m/%d/%Y, %H:%M:%S"))

utc_dt = datetime.now(timezone.utc)
print("Starting process at Local time {}".format(utc_dt.astimezone().isoformat()))

tailnet = os.environ.get('TAILNET')
token = os.environ.get('TAILSCALE_TOKEN')
base_url='https://api.tailscale.com/api/v2'
headers = {'Authorization': 'Bearer {}'.format(token)}

def get_devices():
    tailnet_devices_url = '{}/tailnet/{}/devices'.format(base_url, tailnet)
    response = httpx.get(tailnet_devices_url, headers=headers)
    response_json = response.json()
    return response_json.get("devices")

def delete_device(id: str, dryrun: bool):
    print("Deleting device {}".format(id))
    if (dryrun):
        return True

    delete_device_url = '{}/device/{}'.format(base_url, id)
    print("----------------")
    print(delete_device_url)
    print("---------------")
    try:
        response = httpx.delete(delete_device_url, headers=headers)
        response.raise_for_status()
        print(response.reason_phrase)
        return response.is_success
    except httpx.TimeoutException:
        print("The request timed out.")
    except httpx.RequestError as exc:
        print(f"An error occurred while requesting {exc.request.url!r}.")
    except httpx.HTTPStatusError as exc:
        print(f"Error response {exc.response.status_code} while requesting {exc.request.url!r}.")
    except httpx.ConnectError as exc:
        print(f"Error response {exc.response.status_code} while connecting {exc.request.url!r}.")

def is_older_than_n_days(value: date, n: int):
    # Create a date object for the current date
    today = date.today()
    # Calculate the starting date (N days ago)
    start_date = today - timedelta(days=n)
    # Check if the given date is older than N days
    if (value < start_date):
        return True
    else:
        return False

def get_device_ids_older_than_n_days(n: int):
    result = []
    devices = get_devices()
    for device in devices:
        tags = device.get("tags")

        # Specify the input format (Z indicates UTC time)
        input_format = "%Y-%m-%dT%H:%M:%SZ"
        device_last_seen = datetime.strptime(device.get("lastSeen"), input_format)

        if (is_older_than_n_days(device_last_seen.date(), n) 
            and tags is not None
            and "tag:subnetrouter" in tags):
            result.append(device.get("id"))
    return result

parser = argparse.ArgumentParser(
            prog="tailscale maintenance",
            description="Removes inactive devices in Tailscale network")
parser.add_argument("-d", "--dryrun",
                    default=False,
                    help="Dryrun",
                    action="store_true")
args = parser.parse_args()

devices_to_be_deleted = get_device_ids_older_than_n_days(0)
print("Devices to be deleted: {}".format(devices_to_be_deleted))
for dev in devices_to_be_deleted:
    delete_device(dev, args.dryrun)
