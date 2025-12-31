{ inputs, lib, outputs, ... }:
lib.extend (
  _: libprev: {
    # namespace for custom functions
    custom = rec{
      # Helper function for generating host configs
      mkHost = 
        { 
          hostname, 
          username ? "nebilam", 
          desktop ? null, 
          platform ? "x86_64-linux" 
        }: 

        let
          isISO = builtins.substring 0 4 hostname == "iso-";
          isLaptop = builtins.substring 0 7 hostname == "laptop-";
          isVm = builtins.substring 0 3 hostname == "vm-";
          isInstall = !isISO;
          isWorkstation = builtins.isString desktop; 

        in 
        # FIXME inputs.nixpkgs.lib.nixosSystem
        lib.nixosSystem {
        specialArgs = {
          inherit 
            inputs 
            # home-manager
            outputs 
            # myLib # TODO added myLib so it can be used in the system config (also add lib?)
            desktop 
            hostname 
            platform 
            username 
            isInstall
            isISO
            isLaptop
            isVm
            isWorkstation;
        };
        modules = [
          ../systems/${platform}
          ../modules
        ]; # NOTE  extra to generate iso: ++ (inputs.nixpkgs.lib.optionals (installer != null) [ installer ]);
      };

      forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      # # ========================== Modules =========================== #
      # # NOTE mkOpt (not mkOption) is a custom lib function 
      # mkOpt = type: default: description:
      #   # NOTE mkOption is a function from nixpkgs lib
      #   lib.mkOption {inherit type default description;};

      # # NOTE mkOpt' is mkOpt without a description (description = null)
      # mkOpt' = type: default: mkOpt type default null;

      # # NOTE mkBoolOpt is mkOpt with type bool
      # mkBoolOpt = mkOpt lib.types.bool;

      # # NOTE mkBoolOpt' is mkBoolOpt without a description (description = null)
      # mkBoolOpt' = mkOpt' lib.types.bool;

      # # NOTE mkEnableOpt is mkBoolOpt' with default valuu of false
      # mkEnableOpt = mkBoolOpt' false;
    };
  }
)