import os
import time
import shutil
import time
import sys
from datetime import datetime

timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
directory = "/tmp"
days_ago = 1
current_time = time.time()
days_in_seconds = 1 * 24 * 60 * 60
log_file = "/dnif/log/file_clean.log"

log_directory = os.path.dirname(log_file)
os.makedirs(log_directory, exist_ok=True)  # Create the log directory if it doesn't exist

def file_clean():
    for root, dirs, files in os.walk(directory):
    for name in files + dirs:
        if "block" in name:
            path = os.path.join(root, name)
            modified_time = os.path.getmtime(path)
            if current_time - modified_time >= days_in_seconds:
                if os.path.isfile(path):
                    os.remove(path)
                    # print(f"File {path} removed.")
                elif os.path.isdir(path):
                    shutil.rmtree(path)
                    # print(f"Directory {path} removed.")
                output = f"{timestamp} : Directory {path} removed."

                with open(log_file, 'a') as file:
                    file.write(output + "\n")


#call the main function
file_clean()

