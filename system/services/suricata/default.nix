{
  lib,
  ...
}:
{
  services.suricata = {
    enable = true;
    settings = {
      af-packet = [
        {
          interface = "ens3";
          cluster-id = 99;
          cluster-type = "cluster_flow";
          defrag = "yes";
          tpacket-v3 = "yes";
        }
      ];

      vars.address-groups.HOME_NET = "[134.122.120.162/20,10.0.0.0/8,172.16.0.0/12]";

      outputs = [
        {
          eve-log = {
            enabled = true;
            filetype = "regular";
            filename = "eve.json";
            community-id = true;
            types = [
              {
                alert.tagged-packets = "yes";
              }
            ];
          };
        }
      ];
    };

    # Don't care about modbus and it doesn't seem to be enabled, so these rules are breaking suricata. Disable them.
    disabledRules = lib.mkOptionDefault [
      "2250001"
      "2250002"
      "2250003"
      "2250004"
      "2250005"
      "2250006"
      "2250007"
      "2250008"
      "2250009"
    ];
  };
}
