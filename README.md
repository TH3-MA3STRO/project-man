# project-man
a set of shell scripts to pull and push repos on startup in order to make development across multiple OSes seamless
Sure, here’s a README that details the setup and usage of the shell scripts for both Windows and Linux.

---
## Table of Contents

- [project-man](#project-man)
  - [Table of Contents](#table-of-contents)
  - [Initial Setup \[*Common for windows and linux*\]](#initial-setup-common-for-windows-and-linux)
  - [Windows Setup](#windows-setup)
    - [Script Setup](#script-setup)
    - [Task Scheduler Setup](#task-scheduler-setup)
      - [Startup Task:](#startup-task)
      - [Shutdown Task:](#shutdown-task)
  - [Linux Setup](#linux-setup)
    - [Script Setup](#script-setup-1)
    - [Systemd Setup](#systemd-setup)
      - [Startup Script](#startup-script)
      - [Shutdown Script](#shutdown-script)
  - [Notes](#notes)
## Initial Setup [*Common for windows and linux*]
1. Clone this repo using

    ```
    git clone https://github.com/TH3-MA3STRO/project-man.git
    ```
## Windows Setup

### Script Setup
1. Modify both the ```.ps1``` scripts and place your username and password in the urls inside the foreach loop
   ```bash
    # Push the latest changes for each repository
    foreach ($repo in $repos) {
        #...#
        git push/pull https://*username*:*password*@repository/file.git --all 
        #...#
    }
   ```
### Task Scheduler Setup

#### Startup Task:

1. Open Task Scheduler.
2. Click on "Create Task..." in the Actions panel.
3. On the General tab, name the task (e.g., "Pull Git Repos on Startup").
4. On the Triggers tab, click "New..." and set the trigger to "At log on".
5. On the Actions tab, click "New..." and set the Action to "Start a program".
    - For Program/script, browse to `powershell.exe`.
    - In Add arguments (optional), enter `-File "C:\path\to\your\pull_repos.ps1"`.
6. Click OK to save the task.

#### Shutdown Task:

1. Open Task Scheduler.
2. Click on "Create Task..." in the Actions panel.
3. On the General tab, name the task (e.g., "Push Git Repos on Shutdown").
4. On the Triggers tab, click "New..." and set the trigger to "On an event".
    - Log: `System`
    - Source: `User32`
    - Event ID: `1074`
5. On the Actions tab, click "New..." and set the Action to "Start a program".
    - For Program/script, browse to `powershell.exe`.
    - In Add arguments (optional), enter `-File "C:\path\to\your\push_repos.ps1"`.
6. Click OK to save the task.

## Linux Setup

### Script Setup
1. Modify both the ```.sh``` scripts and place your username and password in the urls inside the foreach loop
   ```bash
    # Push/Pull the latest changes for each repository
    for REPO in $REPOS; do
        #...#
        git push/pull https://*username*:*password*@repository/file.git --all
        #...#
    done

   ```

Save the scripts and make them executable:

```bash
chmod +x *.sh
```


### Systemd Setup

#### Startup Script

You can add the `pull_repos.sh` script to your `.profile` or `.bashrc`, or create a systemd service.

**Adding to .profile or .bashrc:**

Edit your `.profile` or `.bashrc` and add the following line:

```bash
/path/to/your/pull_repos.sh
```

**Creating a systemd service:**

1. Create a service file `/etc/systemd/system/git-pull.service`:

    ```ini
    [Unit]
    Description=Pull Git Repositories on Startup
    After=network.target

    [Service]
    Type=oneshot
    ExecStart=/path/to/your/pull_repos.sh

    [Install]
    WantedBy=default.target
    ```

2. Enable the service:

    ```bash
    sudo systemctl enable git-pull.service
    ```

#### Shutdown Script

To execute the `push_repos.sh` script on shutdown, you can create a systemd service:

1. Create a service file `/etc/systemd/system/git-push.service`:

    ```ini
    [Unit]
    Description=Push Git Repositories on Shutdown
    DefaultDependencies=no
    Before=shutdown.target reboot.target halt.target

    [Service]
    Type=oneshot
    ExecStart=/path/to/your/push_repos.sh
    RemainAfterExit=true

    [Install]
    WantedBy=halt.target reboot.target shutdown.target
    ```

2. Enable the service:

    ```bash
    sudo systemctl enable git-push.service
    ```


## Notes
- Ensure the paths to your scripts and repository directories are correct.
- Test the scripts and services to ensure they work as expected before relying on them.

