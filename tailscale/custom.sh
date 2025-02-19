#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

# Define a handler function for SIGINT
# handle_sigint() {
#     echo "Caught SIGINT (Ctrl+C). Exiting..."
#     exit 0
#     tailscale logout
# }

# Trap SIGINT and call the handler function
# trap handle_sigint INT

# Function to handle termination signals
handle_term() {
  echo "Caught termination signal! Cleaning up..."
  # Perform any cleanup tasks here
  tailscale logout
  exit 0
}


# Trap termination signals
trap handle_term TERM INT # handles both SIGTERM and SIGINT


# Main script logic
echo "Press Ctrl+C to exit."

# Function to check if Tailscale has an IP address
# wait_for_tailscaled() {
#   while true; do
#     if ip addr show tailscale0 | grep -q "inet "; then
#       echo "Tailscale is up and running with an IP address."
#       break
#     else
#       echo "Waiting for Tailscale to get an IP address..."
#       sleep 3
#     fi
#   done
# }

# # Function to check if a network interface is present
# check_interface() {
#   local interface=$1
#   local timeout=$2
#   local interval=5  # Check every 5 seconds
#   local elapsed=0

#   while [ $elapsed -lt $timeout ]; do
#     if ip link show "$interface" > /dev/null 2>&1; then
#       echo "Network interface $interface is present."
#       return 0
#     else
#       echo "Waiting for network interface $interface to be present..."
#       sleep $interval
#       elapsed=$((elapsed + interval))
#     fi
#   done

#   echo "Network interface $interface is not present after $timeout seconds."
#   exit 200  # Set an error status code
# }


# Function to check if a hostname is an exit node
is_exit_node() {
  echo "Checking if $1 is an exit node..."
  local hostname=$1

  if tailscale status --json | jq -r '.Peer[] | select(.ExitNodeOption == true) | .HostName' | grep -q "^$hostname$"; then
    echo "$hostname is an exit node."
  else
    echo "$hostname is not an exit node."
    exit 100
  fi
}



echo "Starting tailscaled"
# if [ "$TS_USERSPACE" = "true" ]; then
#   FLAGS="${FLAGS} --tun=userspace-networking"
# fi
tailscaled --state=/var/lib/tailscale/tailscaled.state --port=${TSD_PORT:-41641} & # $FLAGS &
# tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/run/tailscale/tailscaled.sock --port=${TSD_PORT:-41641} $FLAGS &
echo "*************************************************************************************************************************************************"

# if [ "$TS_USERSPACE" != "true" ]; then
#   echo "Wait until tailscale interface is up..."
#   # Set the timeout in seconds
#   timeout=10
#   interface_to_check=tailscale0
#   check_interface "$interface_to_check" $timeout
# fi

# wait_for_tailscaled

echo "tailscale login..."
ADVERTISE_TAGS="tag:container"
if [ "$INTERNET_ALLOWED" = "true" ]; then
  ADVERTISE_TAGS="${ADVERTISE_TAGS},tag:internet-allowed"
fi
echo tailscale login --auth-key $TS_AUTHKEY --hostname=${TS_HOSTNAME:-$(hostname)} --accept-dns=${TS_ACCEPT_DNS:-false} --advertise-tags=${ADVERTISE_TAGS}
tailscale login --auth-key ${TS_AUTHKEY} --hostname=${TS_HOSTNAME:-$(hostname)} --accept-dns=${TS_ACCEPT_DNS:-false} --advertise-tags=${ADVERTISE_TAGS}
echo "*************************************************************************************************************************************************"

echo "tailscale up..."
tailscale up --snat-subnet-routes=false --reset
echo "*************************************************************************************************************************************************"


if [ -n "$EXIT_NODE" ]; then
# if [ "$INTERNET_ALLOWED" = "true" ]; then
  # EXIT_NODE=tailscale-metal-vpn
  is_exit_node "$EXIT_NODE"
  echo "tailscale set exit node..."
  tailscale set --exit-node=${EXIT_NODE}
  echo "*************************************************************************************************************************************************"
# fi


echo "Finished all setup"
echo "*************************************************************************************************************************************************"

# Sleep indefinitely
sleep infinity
