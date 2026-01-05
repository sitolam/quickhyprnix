{
  # options,
  config,
  inputs,
  lib,
  pkgs,
  isVm,
  isLaptop,
  username,
  ...
}:

let
  cfg = config.services.rclone;
in
{

  options.services = {
    rclone = {
      enable = lib.mkEnableOption "Enable rclone";
    };
  };

  config = lib.mkIf cfg.enable {
    home.extraOptions =
      let
        rclone-script = pkgs.writeShellScriptBin "reload-rclone" ''
          systemctl --user restart rCloneMounts.service
        '';
      in
      {
        home.packages = with pkgs; [
          rclone
          rclone-script
        ];

        systemd.user.services.rCloneMounts = {
          Unit = {
            Description = "Mount all rClone configurations";
            After = [ "network-online.target" ];
          };
          Service =
            let
              home = "/home/${username}";
            in
            {
              Type = "forking";
              ExecStartPre = "${pkgs.writeShellScript "rClonePre" ''
                remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
                for remote in $remotes;
                do
                name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
                /usr/bin/env mkdir -p ${home}/"$name"
                done
              ''}";

              ExecStart = "${pkgs.writeShellScript "rCloneStart" ''
                remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
                for remote in $remotes;
                do
                name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
                ${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf --vfs-cache-mode writes --ignore-checksum mount "$remote" "$name" &
                done
              ''}";

              ExecStop = "${pkgs.writeShellScript "rCloneStop" ''
                remotes=$(${pkgs.rclone}/bin/rclone --config=${home}/.config/rclone/rclone.conf listremotes)
                for remote in $remotes;
                do
                name=$(/usr/bin/env echo "$remote" | /usr/bin/env sed "s/://g")
                /usr/bin/env fusermount -u ${home}/"$name"
                done
              ''}";
            };
          Install.WantedBy = [ "default.target" ];
        };
      };
  };
}
