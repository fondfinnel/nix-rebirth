{ self, inputs, config, ... }: {

  flake.homeModules.creative = { pkgs, lib, osConfig, ... }: let
    check = osConfig.high-performance && osConfig.headless-check;
  in {

    programs.obs-studio = {
      enable = lib.mkDefault check;
      plugins = with pkgs.obs-studio-plugins; [

    	  wlrobs # wlroots
    	  obs-tuna # track info plugin
    	  obs-vkcapture # vulkan program capture
    	  obs-3d-effect # 3d effects / transitions
    	  obs-multi-rtmp # multiple streaming outputs
    	  obs-mute-filter # truly mute audio
    	  obs-text-pthread # rich text support
    	  obs-source-clone # clone any source
    	  obs-shaderfilter # various filters
    	  obs-replay-source # replay video from memory
    	  obs-source-record # record individual sources / scenes via a filter
    	  obs-scale-to-sound # scale audio based on another source
    	  obs-gradient-source # gradients
    	  obs-backgroundremoval # remove background from video similar to Zoom
    	  obs-pipewire-audio-capture # direct pipewire capture
        obs-composite-blur # blurs
        obs-move-transition
        input-overlay
        obs-retro-effects

      ];
    };

  };


}
