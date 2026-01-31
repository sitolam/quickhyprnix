# Rclone

## Google drive setup

### Pre-setup

[Make your own client_id](https://rclone.org/drive/#making-your-own-client-id)

### Setup google drive

[Google drive](https://rclone.org/drive/)

## Mount drives

Now nixos will mount your configs automatically after a reboot, to mount immediately run `reload-rclone`

## Debugging
Getting authentication error after a while?
Try `rclone config reconnect <config>`
