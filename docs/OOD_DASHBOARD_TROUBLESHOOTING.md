# Open OnDemand Dashboard Troubleshooting Guide

This guide collects the most common troubleshooting questions raised by Open OnDemand Dashboard users and maps them to quick triage steps.
Each section focuses on a specific scenario, summarizing what the user is trying to do, how to unblock them, and when to escalate the issue to the OnDemand team.

## Index

- [Access & Authentication](#access--authentication)
- [Dashboard Navigation & Layout](#dashboard-navigation--layout)
- [Interactive Apps (Batch Connect Sessions)](#interactive-apps-batch-connect-sessions)
- [Files App](#files-app)
- [Job Management (Projects, Launchers, Workflows)](#job-management-projects-launchers-workflows)
- [Active Jobs](#active-jobs)
- [Shell Access](#shell-access)
- [Quotas & Balances](#quotas--balances)
- [Announcements & MOTD](#announcements--motd)
- [Support Tickets](#support-tickets)
- [App Navigation & Discovery](#app-navigation--discovery)
- [Module Browser](#module-browser)
- [User Configuration & Customization](#user-configuration--customization)
- [Browser & Client Issues](#browser--client-issues)
- [Error Messages & Logs](#error-messages--logs)
- [System Integration](#system-integration)
- [Operations & Infrastructure (FASRC-Specific)](#operations--infrastructure-fasrc-specific)
- [Escalation & Log Collection](#escalation--log-collection)

## Access & Authentication

### Login fails with invalid credentials
- **Symptoms**: User reports `Invalid user or password` error despite valid credentials.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot access OOD - connection errors or timeouts
- **Symptoms**: User gets messages like "no internet", "read error", "the requested URL could not be retrieved", or connection timeouts.
- **Resolution**:
  - **Avast Security Software**: If user has Avast antivirus, they should disable the Web Shield feature which can block OOD connections.
  - **Wrong VPN or VPN Realm**: Check that the user is connected to the correct VPN realm:
    - For Cannon OOD: use `username@fasrc` realm
    - For FASSE OOD: use `username@fasse` realm
    - Ensure they are not connected to HUIT VPN instead of FASRC VPN
  - Verify the user can ping or reach the OOD server hostname from their current network
- **Escalation**: If VPN and security software are correctly configured, check for network issues or firewall rules blocking access to OOD servers

### CAS/SAML authentication redirects in a loop
- **Symptoms**: Authentication redirects endlessly or returns `unauthorized`.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Multi-factor authentication (MFA) prompt never appears
- **Symptoms**: Duo or other MFA prompt does not display during login.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Session expires immediately after login
- **Symptoms**: User is returned to login screen immediately after successful authentication.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Forbidden or 403 error when accessing dashboard
- **Symptoms**: User sees `Forbidden` or `403` when reaching `/pun/sys/dashboard`.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### User settings do not persist between sessions
- **Symptoms**: Dashboard preferences, pinned apps, or saved configurations are lost after logout.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot logout from dashboard
- **Symptoms**: Logout button does not work or user remains authenticated after logout.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Impersonating a user for troubleshooting (Operations Staff)
- **Symptoms**: Operations staff need to view the dashboard as another user to troubleshoot issues the user is experiencing. This allows support personnel to see exactly what the user sees without requiring the user's credentials.
- **Resolution**: Open OnDemand supports user impersonation through the User Mapping feature. This allows an authenticated administrator to be mapped to a different system user account. To enable this feature:

  **Prerequisites:**
  - A custom user mapping implementation (such as YCRC's ood-user-mapping) must be deployed
  - Administrative access to the OnDemand server configuration

  **Setup Steps:**
  1. Deploy a customized authentication mapping script to `/opt/ood/customized_auth_map` (or your configured location)
  2. Configure the `user_map_cmd` setting in `/etc/ood/config/ood-portal.yml`:
     ```yaml
     user_map_cmd: '/opt/ood/customized_auth_map/bin/user_map_script'
     ```
  3. Create a mapping file at `/etc/ood/config/map_file` (or location specified in your script)
  4. Add impersonation entries to the mapping file using this format:
     ```
     "admin_username" target_user_account
     ```
     For example, to allow admin `jdoe` to impersonate user `student1`:
     ```
     "jdoe" student1
     ```
  5. Set proper file permissions on the mapping file:
     ```bash
     sudo chown root:root /etc/ood/config/map_file
     sudo chmod 644 /etc/ood/config/map_file
     ```
  6. Regenerate the OnDemand portal configuration:
     ```bash
     sudo /opt/ood/ood-portal-generator/sbin/update_ood_portal
     ```
  7. Restart Apache to apply changes:
     ```bash
     sudo systemctl restart httpd  # or apache2 on Debian/Ubuntu
     ```

  **Using Impersonation:**
  - Once configured, the administrator logs into OnDemand with their own credentials
  - The user mapping script automatically maps them to the target user's account based on the mapping file
  - The administrator now sees the dashboard and all apps as that user would see them
  - All operations (file access, job submission, etc.) are performed as the target user

  **Important Notes:**
  - The mapping file is checked on every HTTP request, so changes take effect immediately (no restart needed)
  - Multiple admins can be granted impersonation capability by adding multiple entries to the mapping file
  - An admin can typically only impersonate one user at a time (determined by the mapping file entry)
  - To switch between users, edit the mapping file to change the target user for that admin
  - This is particularly useful for reproducing user-reported issues in their exact environment

- **Escalation**:
  - **Security Warning**: The mapping file must be carefully protected. Ensure it is owned by root and writable only by root (permissions 644 or more restrictive). Improper permissions could allow unauthorized users to gain elevated access.
  - If the user_map_cmd script is not installed, contact your OnDemand system administrator to deploy a mapping solution that supports impersonation (such as https://github.com/ycrc/ood-user-mapping)
  - If impersonation is not working, check Apache error logs at `/var/log/httpd/error_log` or `/var/log/apache2/error.log` for user mapping errors
  - Verify the mapping script is executable and the mapping file is readable by the Apache user
  - Test the mapping script manually: `sudo -u apache /opt/ood/customized_auth_map/bin/user_map_script "admin_username"`

## Dashboard Navigation & Layout

### Missing dashboard tiles or sections
- **Symptoms**: Expected tiles (Interactive Apps, Clusters, Jobs) are missing from the dashboard.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Navigation sidebar links return 404 errors
- **Symptoms**: Clicking on navigation menu items results in page not found errors.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Dashboard fails to load with blank page or infinite spinner
- **Symptoms**: Dashboard shows blank page or loading spinner indefinitely.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Pinned apps disappear between sessions
- **Symptoms**: Apps that were pinned to favorites are no longer displayed.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Custom navigation menu items not appearing
- **Symptoms**: Configured custom links or menus do not display in the navigation bar.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Dashboard appears in wrong language
- **Symptoms**: Interface displays in unexpected language or shows translation keys.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Interactive Apps (Batch Connect Sessions)

### Interactive app cards missing from dashboard
- **Symptoms**: Expected interactive apps (Jupyter, RStudio, Desktop) are not visible.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### App launch form never displays available clusters
- **Symptoms**: Cluster dropdown is empty or shows no options.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Launch button greyed out or disabled
- **Symptoms**: Cannot submit interactive app launch form; button remains disabled.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Session stuck in Queued state
- **Symptoms**: Interactive session remains in queue indefinitely and never starts.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Session stuck in Starting state
- **Symptoms**: Session status shows "Starting" but never transitions to "Running".
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Session transitions to Failed immediately
- **Symptoms**: Session moves from Queued to Failed without running.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]
 
### I. Session fails within first minute or two
- **Symptoms**: Session runs very briefly then fails.
- **Resolution**: This can happen for a variety of reasons.  This solution is for just one of them.

For a quick workaround, you may be able to uncheck the "Use Jupyterlab instead of Jupyter Notebook" checkbox when starting a new session.

We discuss this issue a bit in our documentation at https://docs.rc.fas.harvard.edu/kb/vdi-apps/#articleTOC_7, [https://docs.rc.fas.harvard.edu/kb/vdi-apps/#articleTOC_7,] however your .bashrc file looks all right and you don't have a .condarc file.

The .condarc file can be created as a result of creating Anaconda/Mamba environments and installing packages inside those environments.

I took a look at one of your recent session's output.log files at
/n/home10/stevenliu/.fasrcood/data/sys/dashboard/batch_connect/sys/Jupyter/output/ae5bd7bb-4fe7-46fa-8b4d-7fae5079b255/output.log
and it looks like it gets stuck with the anyio package.
"ImportError: cannot import name 'run_sync_in_worker_thread' from 'anyio' (/n/home10/stevenliu/.local/lib/python3.8/site-packages/anyio/__init__.py)"
It looks like someone had a similar issue to you, which I found in a search, at https://trac.macports.org/ticket/69357 [https://trac.macports.org/ticket/69357].

I believe that renaming your .local directory would allow you to run JupyterLab again. My suspicion is that there may be conflicts between the packages you have installed, which will end up in your .local directory. One way to avoid this issue and customize your experience with Jupyter is to create Anaconda environments, install your packages into those environments, and load the environment you want when using Jupyter. Jupyter calls these environments "kernels".

To access Mamba environments from within Jupyter, those environments must have the ipykernel and nb_conda_kernels packages installed. Then when you start a new Jupyter session, those will be listed under Kernel -> Change Kernel in Jupyter.

We discuss using mamba in some of our documentation. While it's titled for Python, it's relevant for any situation where you want to load an environment into which you've installed packages specific to your work.
https://docs.rc.fas.harvard.edu/kb/python/ [https://docs.rc.fas.harvard.edu/kb/python/] [https://docs.rc.fas.harvard.edu/kb/python/ [https://docs.rc.fas.harvard.edu/kb/python/]]
https://docs.rc.fas.harvard.edu/kb/python-package-installation/ [https://docs.rc.fas.harvard.edu/kb/python-package-installation/] [https://docs.rc.fas.harvard.edu/kb/python-package-installation/ [https://docs.rc.fas.harvard.edu/kb/python-package-installation/]]
Harvard FAS Informatics has a tutorial about using mamba.
https://informatics.fas.harvard.edu/resources/tutorials/installing-command-line-software-conda-mamba/ [https://informatics.fas.harvard.edu/resources/tutorials/installing-command-line-software-conda-mamba/] [https://informatics.fas.harvard.edu/resources/tutorials/installing-command-line-software-conda-mamba/ [https://informatics.fas.harvard.edu/resources/tutorials/installing-command-line-software-conda-mamba/]]
And there's a Mamba user guide at https://mamba.readthedocs.io/en/latest/user_guide/mamba.html [https://mamba.readthedocs.io/en/latest/user_guide/mamba.html] [https://mamba.readthedocs.io/en/latest/user_guide/mamba.html [https://mamba.readthedocs.io/en/latest/user_guide/mamba.html]]
Mamba is already installed on the cluster, but you'll need to load a relevant module to use it.
We discuss modules at https://docs.rc.fas.harvard.edu/kb/modules-intro/ [https://docs.rc.fas.harvard.edu/kb/modules-intro/] [https://docs.rc.fas.harvard.edu/kb/modules-intro/ [https://docs.rc.fas.harvard.edu/kb/modules-intro/]]
You can learn about what modules are available by using 'module spider [partial module name]' on the command line.

For example 'module spider mamba' will give you a list of a few different Mambaforge modules you could load.
elawrence@holylogin07 ~]$ module spider mamba
-------------------------------------------------------
Mambaforge:
-------------------------------------------------------
Description:
Mamba Python Implementation
Versions:
Mambaforge/22.11.1-fasrc01
Mambaforge/23.3.1-fasrc01
Mambaforge/23.11.0-fasrc01

If I wanted to load the newest one, I could do this
elawrence@holylogin07 ~]$ module load Mambaforge/22.11.1-fasrc01
[elawrence@holylogin07 ~]$ module list
Currently Loaded Modules: 1) Mambaforge/22.11.1-fasrc01
[elawrence@holylogin07 ~]$

From there I can use mamba commands to create a new environment, including the packages I want to install with 'mamba create -n <ENV_NAME> <PACKAGES>', or just create the environment with 'mamba create -n <ENV_NAME>', activate (enter the environment) it with 'source activate <ENV_NAME>', and then install packages with 'mamba install <PKG_NAME>'.

Do keep in mind that if you have several packages installed in your .local, or if you have Mamba environments with several packages, they can take up significant space in your home directory.
You can check your home directory quota usage with
quota .
We discuss quota usage at https://docs.rc.fas.harvard.edu/kb/checking-quota-and-usage/ [https://docs.rc.fas.harvard.edu/kb/checking-quota-and-usage/] [https://docs.rc.fas.harvard.edu/kb/checking-quota-and-usage/ [https://docs.rc.fas.harvard.edu/kb/checking-quota-and-usage/]]
and there's more information about how to find out what folders are taking the most space and how to clear up space at
https://docs.rc.fas.harvard.edu/kb/home-directory-full/ [https://docs.rc.fas.harvard.edu/kb/home-directory-full/] [https://docs.rc.fas.harvard.edu/kb/home-directory-full/ [https://docs.rc.fas.harvard.edu/kb/home-directory-full/]]

- **Escalation**: [To be developed]

### II. Session fails within first minute or two
- **Symptoms**: Session runs very briefly then fails.
- **Resolution**: The user may not have specified enough time, memory, CPU, or some combination of the three.  The job should be resubmitted with more resources.
- **Escalation**: [To be developed]

### III. Session fails within first minute or two
- **Symptoms**: Session runs very briefly then fails.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### VNC/noVNC window launches but fails to connect
- **Symptoms**: VNC viewer opens but shows `Failed to connect to server` or connection error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### VNC window is black or unresponsive
- **Symptoms**: VNC connection succeeds but displays only black screen or does not respond to input.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot connect to SSH node from interactive session
- **Symptoms**: SSH connection to compute node fails or times out.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Jupyter or RStudio prompts for password unexpectedly
- **Symptoms**: Interactive app requires password when it should use token authentication.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot delete or cancel running session
- **Symptoms**: Delete/cancel button does not work or session remains active.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Saved session settings not loading
- **Symptoms**: Previously saved launch parameters do not auto-populate in the form.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Session data directory access issues
- **Symptoms**: Error accessing session staging directory or connection files.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Invalid form submission or validation errors
- **Symptoms**: Form shows validation errors that are unclear or incorrect.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Invalid account or account/partition combination specified
- **Symptoms**: User gets an error message when launching an interactive app:
  ```
  Failed to submit session with the following error:
  sbatch: error: Batch job submission failed: Invalid account or account/partition combination specified
  If this job failed to submit because of an invalid job name please ask your administrator to configure OnDemand to set the environment variable OOD_JOB_NAME_ILLEGAL_CHARS.
  The RStudio Server session data for this session can be accessed under the staged root directory.
  ```
- **Resolution**: One possible cause is that the user's account was dropped from the scheduler due to not having submitted a job recently. The solution is to try to start another job. Sometimes it can take a few minutes for slurm to catch up, so if it fails again, keep trying. If it takes more than 5 minutes, something different is wrong.
- **Escalation**: If the issue persists after multiple attempts over several minutes, verify the user's account status with the scheduler directly using commands like `sacctmgr show assoc user=username` to check if their account associations are valid.

### "We're sorry, but something went wrong" error
- **Symptoms**: User gets error message:
  ```
  We're sorry, but something went wrong.
  The issue has been logged for investigation. Please try again later.
  Technical details for the administrator of this website
  Web application could not be started by the Phusion Passenger(R) application server.
  ```
- **Resolution**: Check the user's home directory storage usage with `df -h`. They might have run over their quota and/or have sparse files. Ask the user to clean up their home directory or request a quota increase if appropriate.
- **Escalation**: If quota is not the issue, check the Passenger application logs in `/var/log/ondemand-nginx/${USERNAME}/` for specific application startup errors. The per-user NGINX error logs will typically contain the root cause of the Passenger startup failure.

### Session shows "Undetermined" state with yellow ribbon (OOM issues)
- **Symptoms**: An interactive session (Matlab, RStudio, etc.) displays an "Undetermined" state with a yellow ribbon indicator. The application becomes unresponsive, and reconnection attempts may show 502 Proxy errors.
- **Resolution**: This occurs when a child process within a SLURM job runs out of memory (OOM). SLURM kills the child process but does not automatically kill the parent process, causing the parent (OOD job) to hang and become unresponsive. The user is not warned, the session is not killed automatically, and the application becomes unresponsive.

  The user needs to request more memory when launching their next session. They should delete the current unresponsive session and relaunch with increased memory allocation.

  **Technical Background**: To prevent the parent process from hanging, the following approach can be implemented in the app's job script by setting `oom_score_adj` to ensure the parent process is terminated when the child OOMs:

  ```bash
  # set oom_score_adj to 1000 in job script (parent) so it app is terminated in
  # the event the rsession (child) OOMs to avoid the appearance of the app
  # continuing to function in OOD/Slurm with a 502 Proxy error on reconnect
  echo 1000 > /proc/self/oom_score_adj
  (
    echo 0 > /proc/self/oom_score_adj; $MATLAB_HOME/bin/matlab -desktop -softwareopengl
  )
  ```

  Currently there is no way to explicitly display "Job out of memory" instead of "Undetermined", but this is a potential future improvement.
- **Escalation**: If implementing the `oom_score_adj` solution in batch connect app templates, coordinate with OnDemand administrators to modify the `script.sh.erb` template for affected applications.

### Linker / .so library errors
- **Symptoms**: An interactive app exits immediately after launch. The `output.log` file in the session directory contains dynamic linker errors such as:
  ```
  Error spawning command line 'dbus-launch --autolaunch=123f5e965a284b2d91190b95eef094e8 --binary-syntax --close-stderr': Child process exited with code 1.
  /usr/bin/dbus-launch: /n/sw/lumerical-2023R1-3-aa78b69550/lib/libdbus-1.so.3: version `LIBDBUS_PRIVATE_1.12.8' not found (required by /usr/bin/dbus-launch)
  ```
  This typically indicates a version mismatch between the binaries being executed and the libraries being loaded.
- **Resolution**: This can happen if the `PATH` environment variable is configured with a different (or differently-ordered) set of paths than the `LD_LIBRARY_PATH` environment variable.

  Even if `PATH` and `LD_LIBRARY_PATH` appear to be in agreement when examined on the command line, they can be altered when an OOD app is launched if that OOD app's `script.sh` contains a `module restore` command and the user has default modules configured (in `~/.lmod.d/default`).

  **Solution**: Remove the offending module from the user's list of default modules, or otherwise reconcile the `PATH` and `LD_LIBRARY_PATH` environment variables. The user can check their default modules with:
  ```bash
  module --default list
  ```
  And remove problematic defaults with:
  ```bash
  module --default purge
  # or remove specific module
  rm ~/.lmod.d/default
  ```
- **Escalation**: If the library conflict cannot be resolved by adjusting user modules, the application module itself may need to be fixed to properly manage its library dependencies. Escalate to the software management team to review the module's `LD_LIBRARY_PATH` settings.

### File Manager and Terminal not opening in Remote Desktop app
- **Symptoms**: When using the Remote Desktop interactive app, clicking on File Manager or Terminal does not open the application, or these applications hang indefinitely without opening.
- **Resolution**: This issue can be caused by stuck NFS mounts on FASSE OOD nodes and FASSE compute nodes.

  **Diagnostic Steps**:
  1. Run `strace df -h` on the affected node to see where it's getting stuck mounting
  2. Check the [Grafana dashboard for stuck mounts](https://fasrc.grafana.net/d/e9151667-62b3-4e72-8a26-c82ba7fc016e/mounts?from=now-5m&to=now&timezone=browser&orgId=1) (this may not include OOD login nodes)
  3. If you have access to choria, from b-sa01 you can run:
     ```bash
     choria req shell run command='/bin/bash -c '\''(while read _ _ mount _; do read -t1 < <(stat -t "$mount") || echo "$mount"; done < <(mount -t nfs)) |sort |tr \\n :'\' -W "cluster=fasse role=role::compute" --table
     ```
     This will list stuck mounts on FASSE compute nodes.

  **Solution**: Remove the stuck mounts using `umount -fl` or fix in Puppet.

  To remove mounts manually using choria:
  ```bash
  choria req shell run command='/bin/bash -c "umount -fl /ncf/bursley /ncf/jwb_nki-rs /ncf/pascual-leone /ncf/pascual-leone_cnbs /ncf/pnas /ncf/robertson_lab"' -W "cluster=fasse role=role::compute"
  ```

  To remove a mount permanently via Puppet, use `ensure: absent` in the mount resource. See [this merge request example](https://gitlab.com/fasrc/puppet/puppet-control/-/merge_requests/1798).

  If Puppet won't run until mounts are cleared manually, remove them manually first, then apply the Puppet changes.
- **Escalation**: Coordinate with storage team if NFS mounts are consistently becoming stuck. This may indicate underlying storage server or network issues that need to be addressed at the infrastructure level.

### Remote Desktop: Uncaught Error: zlib inflate failed
- **Symptoms**: When connecting to a Remote Desktop session, the noVNC viewer displays the error:
  ```
  Uncaught Error: zlib inflate failed
  ```
  The VNC connection fails to establish or displays incorrectly.
- **Resolution**: This error occurs when a user has set the compression slider for a session to 0 on the My Interactive Sessions page. Set the compression to any value other than 0 (typically 6 is a good default).

  The user can adjust this by:
  1. Going to My Interactive Sessions
  2. Finding their running Remote Desktop session
  3. Adjusting the compression slider to a non-zero value
  4. Reconnecting to the session

  More information is available in [OOD's Discourse discussion](https://discourse.openondemand.org/t/novnc-error-incomplete-zlib-block-for-interactive-desktop-sessions/2895/7).

  **Note**: OOD 4.x will have a feature that can be enabled to set a default value for this slider, preventing users from setting it to 0 accidentally.
- **Escalation**: If upgrading to OOD 4.x, enable the default compression value feature to prevent this issue from recurring.

### Jupyter session shows "Loading..."
- **Symptoms**: After launching a Jupyter session, the browser shows:
  ```
  Loading... The loading screen is taking a long time. Would you like to clear the workspace or keep waiting?
  ```
  The Jupyter interface never fully loads and remains on this loading screen indefinitely.
- **Resolution**: Try renaming the user's `.local` directory if there's nothing obvious in their `.bashrc` causing the issue:
  ```bash
  cd ~
  mv .local .local.bak
  ```
  Then have the user try launching Jupyter again.

  The user should also check their `.bashrc` file for any commands that might be hanging or taking a long time to execute during shell initialization.

  There is also a user-facing [troubleshooting document](https://docs.rc.fas.harvard.edu/kb/vdi-apps/#articleTOC_7) for this issue.
- **Escalation**: If renaming `.local` and checking `.bashrc` don't resolve the issue, check the Jupyter session's `output.log` in `~/.fasrcood/data/sys/dashboard/batch_connect/sys/jupyter/output/<sessionID>/` (or `.fasseood` on FASSE) for specific startup errors.

### Jupyter session launches and then immediately ends
- **Symptoms**: Jupyter session appears to start successfully (moves from Queued to Running state), but then immediately terminates and returns to Completed state without ever becoming accessible.
- **Resolution**: This is typically caused by conda configuration interfering with Jupyter startup. Check if there's a `conda initialize` section in the user's `.bashrc` file or an `auto_activate_base: false` setting in the user's `.condarc` file.

  **Solution**: Comment out or remove the conda initialization:

  In `.bashrc`, comment out the section between these markers:
  ```bash
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  # ...
  # <<< conda initialize <<<
  ```

  Or in `.condarc`, remove or comment out:
  ```yaml
  auto_activate_base: false
  ```

  This issue is also discussed in [FASRC Docs](https://docs.rc.fas.harvard.edu/kb/vdi-apps/#articleTOC_7).
- **Escalation**: If conda configuration is not the cause, check the session's `output.log` for other startup failures. The issue may be related to conflicting Python environments or Jupyter kernels.

## Files App

### Files app reports unable to access home directory
- **Symptoms**: Files app shows `Unable to stat home directory` error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot navigate to specific directory
- **Symptoms**: Attempting to browse to a path results in permission error or not found.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Upload button missing or disabled
- **Symptoms**: Cannot upload files; upload button is not visible or greyed out.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Drag-and-drop upload stalls at 0%
- **Symptoms**: File upload starts but progress never advances.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### File upload fails with error
- **Symptoms**: Upload attempt results in error message or timeout.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### File transfer "Upload failed" errors
- **Symptoms**: File uploads fail with "Upload failed" error messages. This can occur even for files that should be well within system limits.
- **Resolution**: OOD has a fairly large maximum file size for transfers, but in reality, transfers can fail for sizes well below the maximum. In one documented case, transferring a 2GB file failed.

  **Recommended workarounds**:
  1. Split large files into smaller chunks before uploading
  2. Use alternative transfer methods for large files:
     - `scp` or `rsync` from command line
     - Globus for very large transfers
     - Shell access from OOD to initiate command-line transfers

  For files around 2GB or larger, command-line tools are more reliable than the web-based file upload feature.
- **Escalation**: Reference ticket INC05972118 for details on specific failure cases. If upload failures are occurring at unexpectedly small file sizes (< 500MB), investigate nginx upload limits in the OOD configuration and per-user nginx settings.

### File downloads start but complete with zero-byte files
- **Symptoms**: Downloaded files are empty or corrupted.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot download directory or directory too large
- **Symptoms**: Directory download fails or shows size limit error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### File editor cannot save changes
- **Symptoms**: Edit operation results in `Permission denied` or save fails.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### File editor does not appear or fails to load
- **Symptoms**: Clicking edit button does nothing or shows blank page.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Copy or move operation fails
- **Symptoms**: File operations timeout or result in errors.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Delete operation fails or files reappear
- **Symptoms**: Cannot delete files or deleted files still show in listing.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Favorite paths not working or disappearing
- **Symptoms**: Configured favorite directories are not accessible or do not appear.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Remote files (rclone) connection fails
- **Symptoms**: Cannot browse or access remote file systems configured via rclone.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### File listing shows incorrect permissions or ownership
- **Symptoms**: Displayed file permissions do not match actual filesystem permissions.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Job Management (Projects, Launchers, Workflows)

### Cannot create new project
- **Symptoms**: Project creation form fails or results in error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Project import fails
- **Symptoms**: Attempting to import project template results in error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Project manifest file is corrupted or invalid
- **Symptoms**: Project fails to load with manifest parsing errors.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Launcher form does not display clusters
- **Symptoms**: Cluster options are missing in launcher interface.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Launcher form validation errors unclear
- **Symptoms**: Form shows errors but messages are not helpful or specific.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Job submission fails from launcher
- **Symptoms**: Launcher job submission results in error or timeout.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot find or select job script
- **Symptoms**: Script selection in project shows no options or wrong scripts.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Workflow execution errors
- **Symptoms**: Multi-step workflow fails at specific step or does not progress.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Job monitoring shows no results
- **Symptoms**: Jobs are submitted but do not appear in project job list.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot delete project
- **Symptoms**: Project deletion fails or project reappears after deletion.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Active Jobs

### Jobs not appearing in Active Jobs list
- **Symptoms**: Known running jobs do not display in the jobs interface.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Job status shows incorrect information
- **Symptoms**: Job state does not match actual scheduler status.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot delete or cancel jobs
- **Symptoms**: Delete/cancel action fails or has no effect.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cluster filter not working
- **Symptoms**: Filtering jobs by cluster shows no results or wrong jobs.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Job details page missing information
- **Symptoms**: Job details view does not show expected fields like time remaining or resources.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Active Jobs page fails to load
- **Symptoms**: Jobs page shows error or blank screen.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cluster connection error in Active Jobs
- **Symptoms**: Error message indicates cannot connect to scheduler or cluster.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### HTTP 502 Proxy Timeout Errors
- **Symptoms**: User receives HTTP 502 Proxy Timeout errors when accessing the dashboard, interactive apps, or other OOD features. The error indicates that the Apache reverse-proxy service was unable to receive a reply from the per-user nginx within the configured timeout period.
- **Resolution**: The 502 error indicates a proxy timeout. There are several reasons this could happen:
  1. **Cluster scheduler is overloaded**: The response from SLURM commands is slow
  2. **OOD server is overloaded**: The response from the per-user nginx is slow, or it takes a long time to start
  3. **App initialization delay**: The user is initializing an app for the first time, and the app initialization takes a long while
  4. **Per-user nginx is unresponsive**: The per-user nginx process has become hung or unresponsive

  **Solution steps**:
  1. First, the user should try reloading the page
  2. If the error persists, kill the per-user nginx process (Apache will respawn a new one automatically):
     ```bash
     sudo /opt/ood/nginx_stage/sbin/nginx_stage nginx -u ${USERNAME} -s quit
     sudo /opt/ood/nginx_stage/sbin/nginx_stage nginx_clean --skip-nginx
     ```
  3. Check the responsiveness of the cluster scheduler with command-line SLURM queries:
     ```bash
     scontrol ping
     ```
     If the scheduler is overloaded, errors will persist until scheduler load decreases.

- **Escalation**: If killing the per-user nginx and checking scheduler responsiveness don't resolve the issue, investigate:
  - Apache reverse proxy timeout settings
  - OOD server load and resource utilization
  - Network connectivity between Apache and per-user nginx processes
  - Check Apache logs in `/var/log/httpd/` for proxy-specific errors

### HTTP 503 "Maintenance Mode" Errors masking actual 503 errors
- **Symptoms**:
  - User receives the Maintenance Mode service outage page when the service is not actually in Maintenance Mode (i.e., `/etc/ood/maintenance.enable` is absent)
  - User who should bypass Maintenance Mode (IP in whitelist) receives the maintenance page
  - Errors are logged for the user's client IP address and username in `/var/log/httpd/$(hostname -f)_error_ssl.log`
- **Resolution**: Open OnDemand uses the HTTP 503 (Service Unavailable) status code when serving its Maintenance Mode service outage page. However, since this is implemented by globally overriding the 503 ErrorDocument in `/etc/httpd/conf.d/ood-portal.conf`:
  ```
  ErrorDocument 503 /public/maintenance/index.html
  ```
  The Maintenance Mode page will be displayed for ANY Apache 503 "Service Unavailable" errors, unhelpfully masking the actual error and displaying erroneous information.

  A fix for this issue is forthcoming in a future release of OOD (see [GitHub issue #2196](https://github.com/OSC/ondemand/issues/2196)).

  **Common causes of actual 503 errors**:

  One common cause is when a Passenger app crashes and the socket file is not removed, resulting in errors in the Apache error log:
  ```
  Connection refused: AH02454: HTTP: attempt to connect to Unix domain socket /var/run/ondemand-nginx/jsmith/passenger.sock (*) failed
  ```

  **Solution**: Remove the stuck socket file (it will be re-created automatically):
  ```bash
  rm -f /var/run/ondemand-nginx/${USERNAME}/passenger.sock
  ```

  Whatever the cause of the HTTP 503 error, the details should be in the Apache error log file at `/var/log/httpd/$(hostname -f)_error_ssl.log`.

- **Escalation**: If socket file removal doesn't resolve the issue, investigate the underlying cause of the Passenger app crash or per-user nginx failure in `/var/log/ondemand-nginx/${USERNAME}/` logs.

## Shell Access

### Cannot open shell to cluster
- **Symptoms**: Shell link does nothing or shows error when clicked.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Shell opens but command prompt never appears
- **Symptoms**: Shell window is blank or hangs during initialization.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### SSH authentication fails for cluster shell
- **Symptoms**: Shell shows authentication error or password prompt when using keys.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Shell connection closes immediately
- **Symptoms**: Shell opens then disconnects right away.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cluster not available for shell access
- **Symptoms**: Cluster does not appear in shell access list or menu.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Shell does not load user environment or modules
- **Symptoms**: Shell session does not have expected PATH or environment variables.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Quotas & Balances

### Disk quota not updating or showing incorrect values
- **Symptoms**: Quota display does not reflect current usage.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Quota warning banner appears incorrectly
- **Symptoms**: Warning shows when quota is not exceeded or does not appear when it should.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Balance information missing or outdated
- **Symptoms**: Account balance widget shows no data or stale information.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Quota dashboard widget not appearing
- **Symptoms**: Configured quota display does not show on dashboard.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Quota JSON parsing errors
- **Symptoms**: Error message indicates problem parsing quota data source.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Announcements & MOTD

### Announcements not displaying on dashboard
- **Symptoms**: Configured announcements do not appear to users.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cannot dismiss announcement
- **Symptoms**: Dismiss button does not work or announcement reappears after dismissing.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### MOTD shows formatting errors
- **Symptoms**: Message of the Day displays with broken HTML or markdown.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Announcement file syntax errors
- **Symptoms**: Dashboard shows error loading announcements due to invalid YAML.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Announcements appear for wrong users or groups
- **Symptoms**: Targeted announcements show to unintended audience.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Support Tickets

### Cannot submit support ticket
- **Symptoms**: Support form submission fails or shows error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Attachment upload fails in support ticket
- **Symptoms**: Cannot attach files to ticket or attachment size error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Support ticket form missing fields
- **Symptoms**: Expected form fields do not appear or are not editable.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Ticket submission succeeds but no confirmation
- **Symptoms**: Form submits but user does not receive ticket number or confirmation.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Session or job context not included in ticket
- **Symptoms**: Ticket does not contain expected debugging information.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Support ticket service connection error
- **Symptoms**: Error connecting to RT, ServiceNow, or email ticketing backend.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## App Navigation & Discovery

### System apps not appearing in menu
- **Symptoms**: Expected OnDemand system apps are missing from navigation.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Shared apps not accessible
- **Symptoms**: User-shared or development apps do not appear or cannot be launched.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### App launch fails with error
- **Symptoms**: Clicking app link results in 404 or application error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Invalid app manifest errors
- **Symptoms**: App fails to load due to manifest.yml parsing errors.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### App icons not displaying
- **Symptoms**: Apps show broken image icons or default placeholder.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### App search not returning results
- **Symptoms**: Searching for apps in navigation yields no matches.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Developer mode not working
- **Symptoms**: Development apps are not accessible or sandbox environment fails.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### App categorization or grouping incorrect
- **Symptoms**: Apps appear in wrong category or group in navigation.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Module Browser

### Module browser shows no modules
- **Symptoms**: Module listing page is empty or shows error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Module search not working
- **Symptoms**: Search functionality returns no results or errors.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Module metadata incomplete or missing
- **Symptoms**: Module details do not display version or description information.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Module file directory not configured
- **Symptoms**: Error indicates module path is not set or accessible.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## User Configuration & Customization

### Custom dashboard configuration not loading
- **Symptoms**: User-specific or host-based profile settings are not applied.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Profile switching does not work
- **Symptoms**: Changing profiles has no effect or shows error.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Custom branding not appearing
- **Symptoms**: Configured logo, colors, or title do not display.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Custom CSS or JavaScript not loading
- **Symptoms**: Custom styling or scripts do not take effect.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Feature flags not working as expected
- **Symptoms**: Enabled or disabled features do not match configuration.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Navigation bar customization errors
- **Symptoms**: Custom navigation links or help menu items do not appear.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### User settings file corrupted
- **Symptoms**: Dashboard fails to load due to invalid user configuration.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Browser & Client Issues

### Dashboard unsupported browser warning appears
- **Symptoms**: Browser compatibility message displays to user.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Cached credentials causing login loops
- **Symptoms**: User is stuck in authentication loop due to stale cookies.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Pop-up blockers preventing functionality
- **Symptoms**: VNC or other windows do not open due to browser settings.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Mixed-content warnings in browser
- **Symptoms**: Browser blocks HTTP content embedded in HTTPS dashboard.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Content Security Policy (CSP) violations
- **Symptoms**: Browser console shows CSP errors and functionality is blocked.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### JavaScript errors in browser console
- **Symptoms**: Dashboard features not working and console shows script errors.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Accessibility issues with screen readers
- **Symptoms**: Dashboard is not navigable with assistive technologies.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Page rendering issues or broken layout
- **Symptoms**: Dashboard displays incorrectly or with visual glitches.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Error Messages & Logs

### 404 Not Found errors
- **Symptoms**: Page or resource not found errors in dashboard.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### 500 Internal Server Error
- **Symptoms**: Server error when accessing dashboard or features.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Permission denied errors
- **Symptoms**: User lacks permissions for requested operation.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Where to find dashboard logs
- **Symptoms**: Support staff need to inspect logs for user issues.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### How to enable debug logging
- **Symptoms**: Default logs do not provide enough detail for troubleshooting.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Interpreting nginx error logs
- **Symptoms**: Need to understand per-user nginx (nginx_stage) log messages.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Interpreting Rails/Passenger logs
- **Symptoms**: Need to understand dashboard application log entries.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## System Integration

### Cluster configuration not loading
- **Symptoms**: Configured clusters do not appear in dashboard or apps.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Scheduler adapter errors
- **Symptoms**: Dashboard cannot communicate with job scheduler (Slurm, PBS, etc.).
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### LDAP/Active Directory integration issues
- **Symptoms**: User authentication or group lookups fail.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Reverse proxy configuration problems
- **Symptoms**: Dashboard does not work correctly behind proxy or load balancer.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Filesystem mount issues
- **Symptoms**: Home directory or shared storage not accessible from dashboard.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Clock skew or time synchronization problems
- **Symptoms**: Authentication failures or session issues due to time differences.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Environment variable conflicts
- **Symptoms**: Dashboard behavior incorrect due to conflicting environment settings.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### SELinux or AppArmor policy violations
- **Symptoms**: Operations fail due to security policy restrictions.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

## Operations & Infrastructure (FASRC-Specific)

### Identifying which OOD server a user is connected to
- **Symptoms**: Need to determine which specific OOD backend server a user's session is connected to for troubleshooting purposes.
- **Resolution**: If the user's OOD session is functional, they can see which OOD login server they are using by looking at the bottom of the dashboard (e.g., "You are on b-cannonooda-01").

  If the session is not functional, you will need to check each OOD login server for evidence of their running processes or their username/IP in the logs.

  If you have the job ID, you can run:
  ```bash
  sacct -j <jobID>
  ```
  This will provide information about the job. If the output shows the hostname of the batch node where the job is running, you can check that server with:
  ```bash
  lsload | grep <nodeHostname>
  ```

  You can also use the user impersonation feature (as documented earlier in this guide) to become the user and see what they're seeing.
- **Escalation**: If you cannot locate the user's session on any OOD server, check HAProxy stats to see which backend servers are active and verify load balancer routing.

### Log file locations and structure
- **Symptoms**: Need to locate and examine logs for troubleshooting user issues.
- **Resolution**: The commands below assume the USERNAME variable has been set:
  ```bash
  export USERNAME=someusername
  ```

  **Per-User Job Logs**:
  - On FASSE: `~${USERNAME}/.fasseood/data/sys/dashboard/batch_connect/sys/<applicationname>/output/<sessionID>`
  - On Cannon: `~${USERNAME}/.fasrcood/data/sys/dashboard/batch_connect/sys/<applicationname>/output/<sessionID>`

  In that directory:
  - `connection.yml` contains the node, websocket, and password information. You can use those settings to run the application as that user to test what's happening.
  - `job_script_options.json` gives information on the partition, memory, CPUs, and time requested.
  - `output.log` contains job execution output and errors

  **Per-User NGINX Logs**:
  Per-user NGINX logs are in `/var/log/ondemand-nginx/${USERNAME}/`. This is typically where you will find application errors.

  To determine which OOD server has a specific user's logs, use choria:
  ```bash
  # For Cannon OOD set b:
  choria req shell run command="ls -d /var/log/ondemand-nginx/${USERNAME}" -I /b-cannonoodb/ --table

  # For FASSE set b:
  choria req shell run command="ls -d /var/log/ondemand-nginx/${USERNAME}" -I /h-fasseoodb/ --table
  ```

  **Apache Logs**:
  Apache logs are in `/var/log/httpd/`. This is where you might find proxy or authentication errors. The main log files are:
  - `/var/log/httpd/error_log` - General Apache errors
  - `/var/log/httpd/$(hostname -f)_error_ssl.log` - SSL-specific errors
  - `/var/log/httpd/access_log` - Access logs

- **Escalation**: If logs don't exist where expected, verify the user has successfully authenticated and launched applications. Check that log rotation hasn't archived the needed logs.

### Correlating SLURM job IDs with OOD sessions
- **Symptoms**: Need to correlate an OOD session with its underlying SLURM job ID for troubleshooting or resource tracking.
- **Resolution**: Open OnDemand is scheduler-agnostic, so it does not tightly integrate with the SLURM scheduler. However, it does keep some SLURM job metadata about launched jobs temporarily.

  **Method 1 - From My Active Sessions page**:
  Visit the user's My Active Sessions page in the OOD dashboard and look at the session card details. The job ID is displayed there.

  **Method 2 - From backend cache**:
  Get the SLURM job ID from the session card if it is still in the backend cache (defaults to deleting after 7 days or on user action):
  ```bash
  jq -r .job_id ~${USERNAME}/.{fasrcood,fasseood}/data/sys/dashboard/batch_connect/db/<sessionID>
  ```

  **Method 3 - From output.log**:
  If the session card file has been deleted, the job ID might have been recorded in the `output.log` file in the job `output/<sessionID>` directory (see log locations above). Note: This depends on the app's `script.sh` reporting this value and is not configured for all apps.

  **Method 4 - Using sacct to correlate by WorkDir**:
  You can correlate SLURM job IDs by using `sacct` to pull SLURM job metadata from the scheduler and look for jobs with a working directory matching the OOD session directory. OOD jobs start with their cwd set to the `output/<sessionID>` directory:
  ```bash
  sacct -u ${USERNAME} -S <startDate> -E <endDate> -p -o JobID,WorkDir | grep <sessionID>
  ```

- **Escalation**: If none of these methods yield the job ID and the information is critical, contact the SLURM administrators to search scheduler logs for job submissions from the user during the relevant time period.

### Configuration file locations
- **Symptoms**: Need to modify or inspect OOD configuration files.
- **Resolution**:

  **Global OOD Config**:
  Global Open OnDemand config files are in `/etc/ood/config/`

  **Per-User NGINX Configs**:
  Per-user NGINX configs are in `/var/lib/ondemand-nginx/config/puns/` and are generated from the template `/opt/ood/nginx_stage/templates/pun.conf.erb`

  **Per-App NGINX Configs**:
  Per-app NGINX configs are in `/var/lib/ondemand-nginx/config/apps/sys/` and are generated from the template `/opt/ood/nginx_stage/templates/app.conf.erb`

  **Per-User Per-App (Dev Mode) NGINX Configs**:
  Per-user per-app ("dev mode") NGINX configs are in `/var/lib/ondemand-nginx/config/apps/dev/`. These might need to be re-generated if the path to the dev mode app changes (e.g., because the user's home directory is moved).

  **When Config Changes Take Effect**:
  Different config files are loaded at different times:
  - Some config changes take effect immediately
  - Others require the user to restart their per-user NGINX
  - Some require an admin to [re-generate the Apache "portal" config](https://osc.github.io/ood-documentation/latest/reference/commands/ood-portal-generator.html) and restart the httpd service

- **Escalation**: Consult the [OOD configuration documentation](https://osc.github.io/ood-documentation/latest/) for specific configuration options and their scope.

### Restarting services
- **Symptoms**: Need to restart OOD services to apply configuration changes or resolve service issues.
- **Resolution**:

  **Restarting Apache httpd**:
  In the event that the OOD service is hung or needs to pick up a configuration change to the Apache "portal" config (such as a new SSL certificate), it will be necessary to restart the frontend Apache service:
  ```bash
  sudo systemctl restart httpd
  ```
  (If this results in an error, see the "Apache httpd service fails to (re)start" section below.)

  **Killing Per-User NGINX**:
  In the event that OOD is unresponsive for a particular user, it might be necessary to kill off that user's per-user nginx processes:
  ```bash
  sudo /opt/ood/nginx_stage/sbin/nginx_stage nginx -u ${USERNAME} -s quit
  sudo /opt/ood/nginx_stage/sbin/nginx_stage nginx_clean --skip-nginx
  ```
  Apache will automatically respawn a new per-user nginx when the user next accesses OOD.

- **Escalation**: If service restarts don't resolve issues, check system resource availability (CPU, memory, disk) and investigate for underlying infrastructure problems.

### Apache httpd service fails to (re)start
- **Symptoms**: When attempting to start or restart Apache httpd, the following error is reported:
  ```
  httpd[291357]: httpd (pid 291314) already running
  systemd[1]: httpd.service: Failed with result 'protocol'.
  ```
  This has been observed since upgrading to Rocky 8.
- **Resolution**: This happens when `httpd` somehow gets started outside of `systemctl`/`systemd`, which then becomes unwilling to stop or start the service since it is not managing it. Changes to the Apache `httpd` configuration will not be reflected until `httpd` is restarted.

  The root cause is not yet known. It might be related to the Apache httpd RPM package being upgraded.

  **Solution**:
  1. Check the Apache `httpd` configuration:
     ```bash
     sudo apachectl configtest
     ```
  2. If the configuration is OK, kill the existing httpd processes:
     ```bash
     sudo pkill -f httpd
     ```
  3. Start httpd via systemd:
     ```bash
     sudo systemctl start httpd
     ```

- **Escalation**: If this issue occurs frequently, investigate system package upgrade procedures and consider implementing a systemd service watchdog or implementing pre-upgrade checks to ensure httpd is managed by systemd.

### Managing announcements
- **Symptoms**: Need to create, update, or test OOD dashboard announcements.
- **Resolution**: The OOD "Announcements" feature provides a means to display highly visible banners at the top of the OOD Dashboard. This is useful for announcing upcoming downtime or other messages of urgent general interest.

  **Git-Based Announcement Updates**:
  FASRC OOD is configured to update announcement messages automatically through configuration management (Puppet) from files committed to the [FASRC OOD announcements GitLab repository](https://gitlab.com/fasrc/openondemand/announcements).

  **Different Branches for Different Clusters** (added September 2025):
  - The branch used by Cannon/default is defined in `site-modules/profile/manifests/openondemand.pp`
  - The branch used by FASSE is defined in `data/cluster/fasse.yaml`
  - The master branch is typically used for Cannon
  - A separate 'fasse' branch can be used for FASSE-specific announcements

  If you want both clusters to show the same content, you can either:
  - Have FASSE nodes use the 'master' branch
  - Duplicate the content of the 'master' branch onto the 'fasse' branch and set that branch in `data/cluster/fasse.yaml`

  **Testing Announcements on Dev Nodes**:
  To test your formatting changes to announcements before pushing to production:
  1. Make your edits in a branch of the announcements repo
  2. Edit `site-modules/profile/manifests/openondemand.pp` in a branch:
     ```puppet
     vcsrepo { 'Announcements':
       ensure   => latest,
       provider => 'git',
       source   => 'https://gitlab.com/fasrc/openondemand/announcements.git',
       revision => 'your-test-branch',
       path     => '/etc/ood/config/announcements.d'
     }
     ```
  3. Push this Puppet change to a dev node
  4. Verify the announcement appears correctly on the dev node
  5. Once validated, merge to the appropriate production branch

- **Escalation**: Coordinate with the web/communications team for announcements requiring specific branding or messaging review.

### Blocking and testing OOD nodes with HAProxy
- **Symptoms**: Need to take an OOD node out of production for testing or maintenance while keeping it accessible to FASRC staff.
- **Resolution**: This procedure allows you to block an OOD node from general users but keep it accessible to those in the @hprc or @iqssrc realms of the FASRC VPN.

  **To Block an OOD Node**:
  1. Go to the HAProxy interface for your chosen set of nodes:
     - Cannon OOD set A: http://b-cannonooda-lb-vip.rc.fas.harvard.edu:8888/
     - Cannon OOD set B: http://b-cannonoodb-lb-vip.rc.fas.harvard.edu:8888/
     - Cannon OOD set C: http://b-cannonoodc-lb-vip.rc.fas.harvard.edu:8888/
     - FASSE OOD set A: http://h-fasseooda-lb-vip.rc.fas.harvard.edu:8888/
     - FASSE OOD set B: http://h-fasseoodb-lb-vip.rc.fas.harvard.edu:8888/
     - FASSE OOD set C: http://h-fasseoodc-lb-vip.rc.fas.harvard.edu:8888/
  2. Click on "Disable refresh" on the top right
  3. Select the node that you would like to block
  4. On the drop-down menu, select "Set state to MAINT" to block the node

  **To Connect to a Blocked Node for Testing** (requires @hprc or @iqssrc VPN realm):
  1. Get the IP address of the blocked host:
     ```bash
     nslookup b-cannonooda-01
     ```
     Copy the IP address from the output.
  2. On Mac, edit `/private/etc/hosts` as sudo:
     ```bash
     sudo vi /private/etc/hosts
     ```
  3. Add this line (substitute your actual IP):
     ```
     10.242.123.101 rcood.rc.fas.harvard.edu vdi.rc.fas.harvard.edu vdi-sum-lb-vip.rc.fas.harvard.edu
     ```
     For FASSE:
     ```
     10.x.x.x fasseood.rc.fas.harvard.edu
     ```
  4. Save the file
  5. Connect to https://rcood.rc.fas.harvard.edu (or https://fasseood.rc.fas.harvard.edu for FASSE) in your browser
  6. Verify you're on the blocked node by checking the bottom of the page (e.g., "You are on b-cannonooda-01")

  **To Reopen a Node**:
  1. Go to the HAProxy interface for your chosen set of nodes
  2. Click on "Disable refresh" on the top right
  3. Select the node that you would like to open
  4. On the drop-down menu, select "Set state to READY"

- **Escalation**: Coordinate with the network team if VIP changes or HAProxy configuration modifications are needed.

### Quick diagnostic commands
- **Symptoms**: Need quick system diagnostics and status checks.
- **Resolution**:

  **Puppet Commands** (as root on OOD nodes):
  ```bash
  # Get the current environment for the node
  puppet config print environment --section agent

  # Apply a specific environment to the node
  puppet agent -t --environment eml_h_fasseood

  # View puppet log messages
  grep puppet /var/log/messages | tail -n10
  ```

  **Facter** (as root on OOD nodes):
  ```bash
  # Get information about the host
  facter
  ```

  **Systemctl** (as root on OOD nodes):
  ```bash
  # See if httpd is running successfully
  systemctl status httpd
  ```

  **Choria Commands** (as yourself on sa02):
  ```bash
  # Get massive amounts of information about a specific node, including classes applied
  choria inventory <FQDN>

  # Get information for all OpenOnDemand servers
  choria inventory -W "role=role::openondemand"

  # Get information for FASSE servers only
  choria inventory -W "cluster=fasse role=role::openondemand"

  # Get information for Cannon servers only
  choria inventory -W "cluster=cannon role=role::openondemand"
  ```

- **Escalation**: If diagnostic commands indicate configuration drift or unexpected state, review recent Puppet changes and consider running a full Puppet agent run to reapply configuration.

### Infrastructure overview
- **Symptoms**: Need to understand the OOD infrastructure layout and access points.
- **Resolution**:

  **Cannon OOD (VDI)**:
  - Production URL: https://vdi.rc.fas.harvard.edu/ or https://rcood.rc.fas.harvard.edu/
  - These are CNAMEs for the HAProxy VIP `vdi-sum-lb-vip` which routes to `b-cannonood[a,b,c]-lb-vip`
  - HAProxy routers: `b-cannonood[a,b,c]-lb[01,02,11,12,21,22]`
  - HAProxy admin interfaces:
    - http://b-cannonooda-lb-vip.rc.fas.harvard.edu:8888/
    - http://b-cannonoodb-lb-vip.rc.fas.harvard.edu:8888/
    - http://b-cannonoodc-lb-vip.rc.fas.harvard.edu:8888/
  - Backend OOD servers are listed in the HAProxy admin interface (typically `b-cannonood[a,b,c]-[01-06,11-16,21-26]`)
  - Development and QA infrastructure also exists (see internal OOD Resource Chart)

  **FASSE OOD**:
  - Production URL: https://fasseood.rc.fas.harvard.edu/
  - This is a CNAME for the HAProxy VIP `h-fasseood[a,b,c]-lb-vip`
  - HAProxy routers: `h-fasseood[a,b,c]-lb[01,02,11,12,21,22]`
  - HAProxy admin interfaces:
    - http://h-fasseooda-lb-vip.rc.fas.harvard.edu:8888/
    - http://h-fasseoodb-lb-vip.rc.fas.harvard.edu:8888/
    - http://h-fasseoodc-lb-vip.rc.fas.harvard.edu:8888/
  - Backend OOD servers are listed in the HAProxy admin interface (typically `h-fasseood[a,b,c]0[01-02,11-12,21-22]`)
  - Development and QA infrastructure also exists (see internal OOD Resource Chart)

  **Additional Resources**:
  - Internal OOD Resource Chart: https://runbooks.rc.fas.harvard.edu/hpc/ood/OOD_resource_chart.html
  - Additional OOD instances exist for Academic, NCF, and JHS - consult internal documentation

- **Escalation**: For infrastructure changes or additions, coordinate with systems architecture team and update the OOD Resource Chart accordingly.

## Escalation & Log Collection

### When to escalate to OnDemand core team
- **Symptoms**: Determine if issue requires upstream support.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### When to escalate to local cluster administrators
- **Symptoms**: Identify issues requiring cluster or infrastructure team.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Collecting required log bundles for support
- **Symptoms**: Support ticket requires comprehensive log collection.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Data privacy considerations before sharing logs
- **Symptoms**: Need to sanitize logs before providing to support.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Tracking recurring incidents for platform improvements
- **Symptoms**: Identifying patterns in user issues for upstream bug reports.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]

### Reproducing issues in test environment
- **Symptoms**: Need to replicate user problem for debugging.
- **Resolution**: [To be developed]
- **Escalation**: [To be developed]
