import re
import glob
import os
import yaml

current_directory = os.getcwd()

file_path = os.path.join(current_directory, "time.yaml") 

with open(file_path, "r") as info_file: 
    info_data = yaml.safe_load(info_file)

start_time = info_data["start_time"]
end_time = info_data["end_time"]

def task_received():
    pattern = "Received task:"  # Pattern to grep

    file_patterns = [
        "/DNIF/DL/log/celery_worker_interactive_*",
        "/DNIF/DL/log/celery_worker_reports_*",
        "/DNIF/DL/log/celery_worker_analytics_*"
    ]

    for file_pattern in file_patterns:
        file_paths = glob.glob(file_pattern)
        received_tasks = 0  # Variable to count the received tasks for each file pattern

        for file_path in file_paths:
            with open(file_path, "r") as file:
                content = file.read()

            # Extract lines within the specified time range
            lines = re.findall(r"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}.*", content)
            filtered_lines = [line for line in lines if start_time <= line[:19] <= end_time]

            # Extract lines containing the desired pattern
            matched_lines = [line for line in filtered_lines if pattern in line]

            # Print the matched lines
            for line in matched_lines:
                #print(line)
                received_tasks += 1

        print(f"Number of received tasks for {file_pattern}: {received_tasks}")
        print()

def time_limit():
    timelimt300_pattern_analytics = "TimeLimitExceeded(300)"  # Pattern to grep for timelimt300 tasks
    timelimt900_pattern_interactive = "TimeLimitExceeded(900)"  # Pattern to grep for timelimt900 tasks
    timelimt1800_pattern_reports = "TimeLimitExceeded(1800)"  # Pattern to grep for timelimt1800 tasks

    file_patterns = [
        ("/DNIF/DL/log/celery_worker_interactive_*", timelimt900_pattern_interactive),
        ("/DNIF/DL/log/celery_worker_reports_*", timelimt1800_pattern_reports),
        ("/DNIF/DL/log/celery_worker_analytics_*", timelimt300_pattern_analytics)
    ]

    for file_pattern, pattern in file_patterns:
        file_paths = glob.glob(file_pattern)
        tasks_count = 0  # Variable to count the tasks for each file pattern

        for file_path in file_paths:
            with open(file_path, "r") as file:
                content = file.read()

            # Extract lines within the specified time range
            lines = re.findall(r"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}.*", content)
            filtered_lines = [line for line in lines if start_time <= line[:19] <= end_time]

            # Count tasks based on the pattern
            for line in filtered_lines:
                if pattern in line:
                    tasks_count += 1

        print(f"Number of tasks for pattern {pattern} in {file_pattern}: {tasks_count}")
        print()

def dn_monitor_logs():
    patterns = {
    "port_closed_10000": "Port 10000 is closed",  #it will only work if the logs are in debug 
    "port_closed_10001": "Port 10001 is closed",  #it will only work if the logs are in debug 
    "port_closed_10002": "Port 10002 is closed",  #it will only work if the logs are in debug 
    "correlation_server_down": "Detected correlation_server is down!",  
    "report_server_down": "Detected report_server is down!",  
    "query_server_down": "Detected query_server is down!",  
    "celery_workers_analytics_down": "Detected analytics workers are down!", #only for TCS logs 
    "celery_workers_interactive_down": "Detected interactive workers are down!", #only for TCS logs 
     "celery_workers_reports_down": "Detected reports workers are down!", #only for TCS logs 
    }

    file_patterns = [
        "/DNIF/DL/log/dn_monitor.log*"
    ]

    for file_pattern in file_patterns:
        file_paths = glob.glob(file_pattern)
        counts = {pattern_name: 0 for pattern_name in patterns}  # Initialize counts for each pattern

        for file_path in file_paths:
            with open(file_path, "r") as file:
                content = file.read()

            # Extract lines within the specified time range
            lines = re.findall(r"\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}.*", content)
            filtered_lines = [line for line in lines if start_time <= line[:19] <= end_time]

            # Count occurrences for each pattern
            for line in filtered_lines:
                for pattern_name, pattern in patterns.items():
                    if pattern in line:
                        counts[pattern_name] += 1

        # Print counts for each pattern
        print(f"Counts for {file_pattern}:")
        for pattern_name, count in counts.items():
            print(f"{pattern_name}: {count}")
        print()


# Call the functions 
task_received()
time_limit()
dn_monitor_logs()