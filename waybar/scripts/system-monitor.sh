#!/bin/bash

# Compact system monitor for Waybar
# Outputs: CPU%, MEM%, GPU%, DISK%

icons_cpu="󰘚"
icons_mem="󰍛"
icons_gpu="󰢮"
icons_disk="󰋊"

state_file="/tmp/waybar-cpu-state"

# CPU usage from /proc/stat (two samples via state file)
read -r cpu user nice system idle iowait irq softirq steal guest guest_n </proc/stat
total=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_total=$((idle + iowait))

if [ -r "$state_file" ]; then
  read -r prev_total prev_idle <"$state_file"
  delta_total=$((total - prev_total))
  delta_idle=$((idle_total - prev_idle))
  cpu_used=$(((1000 * (delta_total - delta_idle) / (delta_total == 0 ? 1 : delta_total) + 5) / 10))
else
  cpu_used=0
fi

echo "$total $idle_total" >"$state_file"

# Memory usage percent
read -r _ mem_total _ < <(grep -m1 '^MemTotal:' /proc/meminfo)
read -r _ mem_avail _ < <(grep -m1 '^MemAvailable:' /proc/meminfo)
mem_total_kb=${mem_total}
mem_avail_kb=${mem_avail}
mem_used_pct=$(((100 * (mem_total_kb - mem_avail_kb) / (mem_total_kb == 0 ? 1 : mem_total_kb))))

# GPU utilization
gpu_pct="N/A"
if command -v nvidia-smi >/dev/null 2>&1; then
  gpu_pct=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1)
elif [ -r /sys/class/drm/card0/device/gpu_busy_percent ]; then
  gpu_pct=$(cat /sys/class/drm/card0/device/gpu_busy_percent 2>/dev/null)
elif [ -r /sys/class/drm/card1/device/gpu_busy_percent ]; then
  gpu_pct=$(cat /sys/class/drm/card1/device/gpu_busy_percent 2>/dev/null)
fi

# Disk usage percent for root
disk_pct=$(df -P / 2>/dev/null | awk 'NR==2 {gsub("%","", $5); print $5}')

if [[ -z "$disk_pct" ]]; then
  disk_pct="N/A"
fi

echo "<span color='#f38ba8'>${icons_cpu} ${cpu_used}</span> <span color='#89b4fa'>${icons_mem} ${mem_used_pct}</span> <span color='#a6e3a1'>${icons_gpu} ${gpu_pct}</span> <span color='#f9e2af'>${icons_disk} ${disk_pct}</span>"
