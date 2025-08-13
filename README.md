# System Update and Health Check Script

This script is designed for Debian-based Linux systems to automate system updates and perform basic health checks. It logs all its operations for later review.

## Features

-   **System Updates**: Automatically runs `apt-get update`, `apt-get upgrade`, and `apt-get autoremove` to keep the system up-to-date.
-   **Snap Package Updates**: Refreshes Snap packages if `snap` is installed.
-   **System Health Checks**:
    -   Displays disk space usage for `/dev/sd*` devices.
    -   Shows memory usage.
    -   Lists active network connections.
    -   Performs a network speed test if `speedtest-cli` is installed.
-   **Logging**: All actions are logged to a file in `~/logs/update/`, with a new log file created for each day.

## Prerequisites

-   A Debian-based Linux distribution (e.g., Ubuntu, Debian).
-   `sudo` privileges for the user running the script.
-   `speedtest-cli` (optional) for the network speed test. You can install it with `sudo apt-get install speedtest-cli`.

## Usage

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd <repository-directory>
    ```

2.  **Make the script executable:**
    ```bash
    chmod +x update.sh
    ```

3.  **Run the script:**
    ```bash
    sudo ./update.sh
    ```

## Automation

It is recommended to run this script periodically using `cron`. For example, to run the script every day at 2:00 AM, you can add the following line to your crontab:

```
0 2 * * * /path/to/your/update.sh
```

To edit your crontab, run `crontab -e`.

## Log Files

The script creates log files in the `~/logs/update` directory. The log file is named with the date of execution, for example, `update-check-2025-08-13.log`.
