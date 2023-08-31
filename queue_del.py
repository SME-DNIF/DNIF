import sys
import os
import datetime

# Define the output file path
log_file = "/dnif/log/que_del.log"

log_directory = os.path.dirname(log_file)
os.makedirs(log_directory, exist_ok=True)  # Create the log directory if it doesn't exist

import os
timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
os.environ['WORKDIR'] = '/dnif'

# Create a function to execute the code and capture its output
def delete_queue():
    sys.path.append('/usr/src/nm/core-v9')
    from config_loader import redis_config
    from helpers.redis_helper import RedisHelper
    r_helper = RedisHelper(host=redis_config.RDS_HOST, port=redis_config.RDS_PORT)
    robj = r_helper.get_redis_obj(db="1")

    output_lines = []  # Create an empty list to store output messages

    def get_queue_name_input():
        return input("Enter the queue name (analytics/reports/interactive): ").strip().lower()

    selected_queue_name = get_queue_name_input()

    if selected_queue_name == "analytics":
        analytics_value_del = robj.delete('analytics')
        output_lines.append(f"{timestamp} - Analytics Queue deleted")
        # Additional actions if needed

    elif selected_queue_name == "reports":
        reports_value_del = robj.delete('reports')
        output_lines.append(f"{timestamp} - Reports Queue deleted")
        # Additional actions if needed

    elif selected_queue_name == "interactive":
        interactive_value_del = robj.delete('interactive')
        output_lines.append(f"{timestamp} - Interactive Queue deleted")
        # Additional actions if needed

    else:
        output_lines.append(f"{timestamp} - Invalid queue name selected")

    # Join output lines with newlines
    output = '\n'.join(output_lines)

    # Write the output to the log file
    with open(log_file, 'a') as file:
        file.write(output + "\n")

# Execute the code and write to the file
delete_queue()
