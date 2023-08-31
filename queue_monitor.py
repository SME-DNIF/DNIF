import sys
import os
import datetime

# Define the output file path
log_file = "/dnif/log/que.log"

log_directory = os.path.dirname(log_file)
os.makedirs(log_directory, exist_ok=True)  # Create the log directory if it doesn't exist

timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
os.environ['WORKDIR'] = '/dnif'

# Create a function to execute the code and capture its output
def queue_check():
    sys.path.append('/usr/src/nm/core-v9')
    from config_loader import redis_config
    from helpers.redis_helper import RedisHelper
    r_helper = RedisHelper(host=redis_config.RDS_HOST, port=redis_config.RDS_PORT)
    robj = r_helper.get_redis_obj(db="1")

    analytics_value_llen = robj.llen('analytics')
    reports_value_llen = robj.llen('reports')
    interactive_value_llen = robj.llen('interactive')

    output_lines = []
    
    if analytics_value_llen is not None: 
        output_lines.append(f"{timestamp} - Analytics Queue is : {analytics_value_llen}")
    else:
        output_lines.append(f"{timestamp} - Analytics Queue is Zero")

    if reports_value_llen is not None: 
        output_lines.append(f"{timestamp} - Reports Queue is : {reports_value_llen}")
    else:
        output_lines.append(f"{timestamp} - Reports Queue is Zero")

    if interactive_value_llen is not None: 
        output_lines.append(f"{timestamp} - Interactive Queue is : {interactive_value_llen}")
    else:
        output_lines.append(f"{timestamp} - Interactive Queue is Zero")

    # Join output lines with newlines
    output = '\n'.join(output_lines)
    
    # Write the output to the log file
    with open(log_file, 'a') as file:
        file.write(output + "\n")

# Execute the code and write to the file
queue_check()

