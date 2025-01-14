import subprocess
import re

def parse_add_files():
    status_output = subprocess.check_output(["git", "status"]).decode()

    untracked_files = []
    lines = status_output.splitlines()[:-2]
    for i in range(len(lines)):
        if lines[i].startswith("Untracked files:"):
            for j in range (i+2, len(lines)):
                filename = lines[j].strip()
                untracked_files.append(filename.split("/")[-1])
            break
    if len(untracked_files) == 0:
        return ""
    return f"ADD {', '.join(untracked_files)} "

def parse_git_diff():
    diff_output = subprocess.check_output(["git", "diff", "-U0"]).decode()
    added_files = []
    removed_files = []
    modified_files = {}

    for line in diff_output.splitlines():
        if line.startswith("diff --git"):
            file_paths = line.split(" ")[2:]
            file_path = file_paths[-1].split("/")[-1]
        elif line.startswith("deleted file"):
            removed_files.append(file_path)
        elif line.startswith("new file"):
            continue
        elif line.startswith("+") and re.match(r"^\s*(-|\+)\s*(\w+):\s*", line): 
            key = re.search(r"(\w+):\s*", line).group(1)
            if file_path not in modified_files:
                modified_files[file_path] = []
            modified_files[file_path].append(key)

    message = parse_add_files()
    if removed_files:
        message += f" RM {', '.join(removed_files)} "
    if modified_files:
        message += " MODIFIED " 
        for file, keys in modified_files.items():
            message += f"{file.split('.')[0]}.{','.join(keys)}  "
    return message.strip()


# diff_output = subprocess.check_output(["git", "diff", "-U0"]).decode()
print(parse_git_diff())