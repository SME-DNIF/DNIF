import sys
import os
import datetime
import redis.exceptions

sys.path.append('/usr/src/nm/core-v9')
from config_loader import redis_config
from helpers.redis_helper import RedisHelper

import os

os.environ['WORKDIR'] = '/dnif'

# Define the output file path
log_file = "/dnif/log/que.log"

log_directory = os.path.dirname(log_file)
os.makedirs(log_directory, exist_ok=True)  # Create the log directory if it doesn't exist

# Create a function to execute the code and capture its output
def execute_code_and_write_to_file():
    r_helper = RedisHelper(host=redis_config.RDS_HOST, port=redis_config.RDS_PORT)
    robj = r_helper.get_redis_obj(db="1")
    
    try:
        analytics_value = robj.get('analytics')
        reports_length = robj.llen('reports')  # Get the length directly
        interactive_value = robj.get('interactive')
    except redis.exceptions.RedisError as e:
        print(f"Redis error: {e}")
        return
    
    timestamp = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    output_lines = []

    if analytics_value is not None:
        output_lines.append(f"{timestamp} - Analytics Length: {len(analytics_value)}, Value: {analytics_value}")
    else:
        output_lines.append(f"{timestamp} - Analytics Value is None")
        
    output_lines.append(f"{timestamp} - Reports Length: {reports_length}, Value: {reports_length}")  # Use reports_length directly
       
    if interactive_value is not None:
        output_lines.append(f"{timestamp} - Interactive Length: {len(interactive_value)}, Value: {interactive_value}")
    else:
        output_lines.append(f"{timestamp} - Interactive Value is None")
    
    # Join output lines with newlines
    output = '\n'.join(output_lines)
    
    # Write the output to the log file
    with open(log_file, 'a') as file:
        file.write(output + "\n")

# Execute the code and write to the file
execute_code_and_write_to_file()