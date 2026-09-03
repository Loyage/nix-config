_: {
  programs.noctalia.settings = {
    plugins = {
      auto_update = false;
      source = [
        {
          kind = "git";
          location = "https://github.com/noctalia-dev/official-plugins";
          name = "official";
        }
        {
          kind = "git";
          location = "https://github.com/noctalia-dev/community-plugins";
          name = "community";
        }
      ];
      enabled = [
        "avivbintangaringga/nix-monitor"
        "alexander/screen-toolkit"
      ];
    };

    # Per-plugin settings -> [plugin_settings."author/plugin"] in config.toml
    plugin_settings."alexander/screen-toolkit".selected-ocr-lang = "chi_sim+eng";
  };
}
