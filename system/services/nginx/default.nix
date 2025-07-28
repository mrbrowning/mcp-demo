{
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d /var/www/website.com/public_html 0755 mbrowning nginx -"
  ];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;

    virtualHosts."website.com" = {
      locations."/" = {
        root = "/var/www/website.com/public_html";
        tryFiles = "$uri $uri/ $uri/index.html =404";
      };
    };

    virtualHosts."www.website.com" = {
      globalRedirect = "website.com";
    };

    # Default server for other subdomains - returns 404
    virtualHosts."_" = {
      default = true;

      locations."/" = {
        return = "404";
      };
    };
  };
}
