{ self, inputs, config, ... }: {

  flake.nixosModules.kanata = { lib, config, pkgs, ... }: {

    # Module for kanata keyboard tool, home row mods of laptop.
    # Keys this changes, associated replacements:
    # - rebinds A, S, D, F, to, on hold, super, alt, shift, and ctrl
    # - Mirrored J, K, L, ;
    # - Rebinds caps to escape, escape to caps
    # Note: Force kanata to exit with ctrl + space + esc

    services.kanata = {
      enable = lib.mkDefault true;

      keyboards.default.extraDefCfg = "process-unmapped-keys yes";
      keyboards.default.config = ''
      (defsrc
        a
        s
        d
        f
        j
        k
        l
        ;
        caps
        esc
      )

      (defalias
        a-mod (tap-hold 200 200 a lmet)
        s-mod (tap-hold 200 200 s lalt)
        d-mod (tap-hold 200 200 d lshift)
        f-mod (tap-hold 200 200 f lctrl)
        j-mod (tap-hold 200 200 j rctrl)
        k-mod (tap-hold 200 200 k rshift)
        l-mod (tap-hold 200 200 l ralt)
        ;-mod (tap-hold 200 200 ; rmet)
        caps-mod esc
        esc-mod caps
      )

      (deflayer base
        @a-mod
        @s-mod
        @d-mod
        @f-mod
        @j-mod
        @k-mod
        @l-mod
        @;-mod
        @caps-mod
        @esc-mod
      )
    '';

    };

  };


}
