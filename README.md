# Docker.Halyard

Docker script for a Linux image capable of running Halyard, useful to run Halyard on Windows via Docker.

# Building

```
docker build .
```

# Using on Windows

1. Run the following command to register the "hal" function in your Powershell session (be sure to include the "." before the command, so there are two dots):

```powershell
. .\register-hal.ps1
```

2. Run this command to start the Halyard daemon inside a Docker container:

```powershell
hal start
```

3. Run Halyard commands

```powershell
hal backup restore --backup-path halbackups/halbackup-Thu_Oct_12_19-13-33_UTC_2017
hal deploy apply
```

4. Stop the Halyard daemon when done

```powershell
hal stop
```

# Notes About Persistence

The internal Halyard configuration is persisted to a Docker volume, even after calling `hal stop`. The next time you run `hal start` Halyard will be in the state where you left it, so long as the Docker volume was not destroyed.  If the volume was destroyed, your configuration will need to be restored from a backup.

# Backup and Restore

Backups created with `hal backup create` will be placed in `${HOME}/.halbackups` on your computer. To restore backups, place the backup file in the same folder and include `halbackups/` before the filename, i.e. `hal backup restore --backup-path halbackups/halbackup-Thu_Oct_12_19-13-33_UTC_2017`.

# Kubernetes Credentials

Your local `${HOME}/.kube` folder is mounted (read-only) to `~/.kube`, which allows Halyard to access your Kubernetes configuration file to get credentials.  Once you make a backup, these credentials are then moved to the backup file.