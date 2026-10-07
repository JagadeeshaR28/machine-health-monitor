# Machine Health Monitor

A simple Ubuntu shell script that checks the health of a machine by monitoring:

- CPU usage
- Memory usage
- Disk usage

If any metric exceeds 60%, the machine is reported as unhealthy. Otherwise, it is reported as healthy.

## Features

- Checks CPU usage
- Checks memory usage
- Checks disk usage
- Supports a default mode and an explanation mode
- Works on Ubuntu-based systems

## Requirements

This script is designed for Ubuntu and uses standard Linux tools such as:

- `top`
- `free`
- `df`

These are commonly available on Ubuntu systems.

## Installation

1. Save the script as `machine-health.sh`
2. Make it executable:

```bash
chmod +x machine-health.sh
```

## Usage

### Default mode
This prints only the current health status:

```bash
./machine-health.sh
```

Example output:

```bash
healthy
```

or

```bash
unhealthy
```

### Explain mode
This prints the health status and explains why the machine is healthy or unhealthy:

```bash
./machine-health.sh explain
```

Example output:

```bash
Machine health status: unhealthy
CPU usage: 72%
Memory usage: 58%
Disk usage: 81%
Reason:
 - CPU usage is 72% (threshold: 60%)
 - Disk usage is 81% (threshold: 60%)
```

## Health Rule

The script uses a threshold of 60%:

- If CPU > 60% => unhealthy
- If Memory > 60% => unhealthy
- If Disk > 60% => unhealthy

If all values are below or equal to 60%, the machine is considered healthy.

## Notes

- The script checks the root filesystem (`/`) for disk usage.
- This is appropriate for basic health monitoring in Ubuntu environments.
- For production monitoring, you may want to add log files, alerts, or a monitoring tool such as Prometheus, Grafana, or Nagios.
