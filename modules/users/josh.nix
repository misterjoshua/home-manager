{
  self,
  ...
}:
let
  stateVersion = "24.11";
  homeImports = [
    self.modules.homeManager.nix
    self.modules.homeManager.shell
  ];
in
{
  flake = {
    modules.homeManager.josh =
      { ... }:
      {
        imports = [
          self.modules.homeManager.homeManager
        ]
        ++ homeImports;

        home = {
          username = "josh";
          homeDirectory = "/home/josh";
          inherit stateVersion;
        };
      };

    modules.nixos.josh =
      {
        ...
      }:
      {
        imports = [
          self.modules.nixos.homeManager
        ];

        users.users.josh = {
          isNormalUser = true;
          description = "Josh";
          extraGroups = [
            "networkmanager"
            "wheel"
          ];

          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC0X7BKGZFvicoT9fnDZTjg2OaGjfTtXgTPwK72PgXbmyDujkEgl8h2GvWu9fWkHaPGVol2zymKbGQy25d8MoPQ+nxMv3L2pR9r/DNJpQFNU76OTam6AkKJsajoAz4dikwjE+wvquMPDVm/1Dgb4e+5DUnCUlK6Ndnf/7IcVcbUpCsXSs8FW0yj83EuPbjkCsEQ63BsmACeyAPJQODwb9nZ9kDJG1MW134UXdRdHr5Tj72bBCO3rYOFx3sJjWLwNZuZk8lu3QdLoYVD/Xz5pyfPH3qA2meP647SZSnSiRrotBgAHab/AbsW/7BDEwtBe9/6CN7nGaU5HD+3kMW2vq1CJXmgbpWBK82pVkKdPaJSfC1/7EaVao88lz8pJMSOB1nOeNp4B705v9Rv4qLcBVnB3fQK7YxXdpJVg3zRPClH1lZ8fuZFIkF6CSOx3YivzD5v6TZ580JK/FyLOi9szhLMQ/MIfWN46yIeRCz+8YwPRA8QIoZI+yp5UzePG52NH5J5yRDOVSpPHzz1b7GPQMvmCoEgddk+QFkETEfp819pkAnE/GrB+QlwhjhZulKQHd+XkMO6QqtZIlh9infPDk2gB/oBKLjtBfCJFD5F0xV9E0aFZE69gBqTYSU4BjnSG9a8KffKJTxFy80V2Gy9KkpGmmNupqXXVyU3fOxhR6I82w== misterjoshua@github/31782857 # ssh-import-id gh:misterjoshua"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCymWbTQ2lToUSf3zhr1qRy0+/GPnfGJKzHIqSC94ueTJlkh89Mast3IK4MsyMPwtX0K+BXPnJlbCArD7CkdjH37aGlEiBQhXmvi245u98y53bUoKtKZ58ahkFVCt12D3cQiNdRcQB+1k4Qwn1XYcjxtwYHizj3Hl+P+MSc0rh1ruycIAkvwK/KsoY1p77O384fcX/XmFCXnKcnM3IGijJkHvYvSRuSQ/94Wyjql+YKAdfK3Ixo6iJmpAd/RuR3veOMcAVUwUeuwUJi+dBj7E9rN1nKgn0jpBfJQjbcNvOCQjg19KpV2CVisM5X/IUt/egbiwK5SJY5GQVUREqslmqB misterjoshua@github/38222878 # ssh-import-id gh:misterjoshua"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDnvc7pyAuVvfgk9LhYwdQc9l83/GX+9hwGUR1HXUVaL+Mkro6XVr33sdSRUUPFH3TGHtz0xUkBsblC0bLaCq6LRKP5BELKJhrCfkzqQdBYo6GiGHVVn1zv4IZvZ/kI5XGwqS0iefaQ7vj+TSi4rWXg3mulxnygIhGmqsl74IWWhdrvQ7Z7CEMIzirRPaVTCJyYhhjRt0V+w1lPC4LoWtgCZngvRu71CwWhfJBYjMztJ2QrZSnMAl7lK3INYhfXAW6APZ/ao9ePjgzs+huuulrPIhpBLGvO5Un61fql+dmtcxMDIOss+DjyJGFkoGAZ2me666i4MrfIKaOikIroxTuH+Y64tkP/iD27BQx8OZzyt0Eq1/HLk+tZJoRGzBCbFTIiJH8081uKTwWsAlbQ+TAG6zNjrEgzGClCf/gRI0/Td8+v/l9P+roCDjRhLh+1cq/Tw5DE2tFqH76vWeQ7w4z27oSl7QEeRodCoqic8s48HGJE0wgaRNLedKwj/lrYKLTT2/WKMU+LacjTrcTWf7GbnuKtqljDoI/nvyGph3A3uupfN4uZK0qP6MNkTIBszAKyTJ7LjC82yehLPnpdQ5P5uKQUQ1+itGVrvsRNpKfz1XCOjT3VrHSIVFyaUiJTxpdnF0gph7RXsBacogifLjbf0kV+BRjM2snVb4vLF2QwGw== misterjoshua@github/60225977 # ssh-import-id gh:misterjoshua"
          ];
        };

        home-manager.users.josh = {
          imports = homeImports;
          home.stateVersion = stateVersion;
        };
      };
  };
}
