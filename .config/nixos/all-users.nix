{ config, pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;
  users.extraUsers.ditadi = {
    uid = 1000;
    isNormalUser = true;
    name = "ditadi";
    group = "ditadi";
    extraGroups = [
      "wheel" "disk" "audio" "video"
      "network-manager" "systemd-journal"
      "docker"
    ];
    createHome = true;
    home = "/home/ditadi";
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfzW8cMR/+eRv7tCWc7GZ/DmmzjhowgogBgm//Xi4r7yfwJyzOkWyMR/CLFQR/83qRRZV3VteSF3R8HYNjL4Rl6lYCN5pRUbcAgU9ZXxeEAVGXDVHUr2rxNBDfIzimFDCiwRQzM2XOoCEEd2oi7FyXGJ+VV16LqKkSmDtPfN9BP+bUYVRqzDY57Y6Mjlv0G66T5GegyJ/lEI5sL/Y5wVtIOcHkSMkpq4QhW6X8CIYsQrve2Derx/d2pqWDhuMhxi+D8P2x0KjztwIHuNjxRP8sHg/e4jC1+ambu/OwqRDQfdYM8yK5AUt9PRR5pd9myPHtKlkuXZsKdPMhgmlvemA5 dmitriy@tadyshev.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCzc40HdmNxpX7gyu5OPc/JbSJZgfqsDTTWhq7jurA/rBF/eN12qGEdrK3uF++6AdABiAnJugmuDbYGjcBN/xSp21OWMYYh/c2CYsVQKQjPV5CXwqL+82OdIOJdvXv4s/jfqh/Sb0LXaoi2mYZ6SnGfkhsoycuQh12A5VKNcGeSPzMcvcpv/5+glLSlJPyVWyXKG1mn5smHKCzPJAhijVgPbvVDPPyIjmQTwUI0O41GXeqOB115nmp5YgsSrYK/P8y6lt+wyB70oVBHrCLadDwUv9NHW1JfsE5iDw3Pq88PexGrrzXvxbELy1NMEA7+oZMZjHtknWEQNQT+zMb+P0K7sduA5nQN1dNaHMDMPTKfngs54xVayhIEyxQys1iTmUHc/lJcX1OG/seLMKz+vuXE+lJbNNQNPrysfjojob9/TnSw4Jc7CNttAdN1qIogF+aI0L+FshUAoDH2QQ96xiWVdEo/iubuRfn/1Ctg4h25pu+Ip72Oc0MsAvZi91EkCpjyZk0B6j84NJS6Ng4VWIm7k6PR1FL01vrKAbdP/CjkMtRNA2ROHpKd0b/TR19BMMSv5AF9Woq27KD3Updp7CXYS7Ff94KvsYyhq0TDCo40ukThvoKfe7u1h+o5vJAPSxiaBYc9fY3a+nuvM5lpSEVzUVs9qHM9UbFayuWchkwVNw== dmitriy@tadyshev.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC14YLBd4BSueOQvWAjTJuIfs8h5+Ba++jWDuf5VlFov29YE/ZxCFBh6H4c5vOaP+EAvAg5/8Tx1h0tm2JU/B9CUmscdlucAAvYFesKAIq6McovhFJo+DfA0QX34UIumL79QtIPPRo9ARcp94eQlSXKOVnCkyh3V6B9eTF7TLIetUzVZ2X2uMEtbNTKhGpITNJveck5qeYMFwC8WEqwCYSY+ZpokOSTrcARmZt+mmXJvdvqPx+l0YBP6Y92QLw6jNigoAZ8dGWMp5kctU5rfd4LrzdKFAJ7G86JjrD8VHpkFapnfWE0r/mgoC3sILI+E2f+uuBGpoeSWnK3Qkjmp8zl+44SubNOuN2lghGaeFcZFBoDVHFoYQPczf5GZBcYMhLA0tDqMXweuYQyd9EnSsm4n11TKF8eA6UiFThls5s1wsw7EdZIc/9GLS1O/IH3Z9XU53se0izyVAJW/40UY1L0en3mTE7964fsjqmde2Jyi0dlCTjm1V4LrUxoOv3pFO11xlUlm5uEyijc2okpLPwEdSiGvBbqdOPrsHvcWuavDEzKIK1pP5uqHoJjlV4/MS3Mhbeu6dmAUq8d2gFmlMx+nPzPzb7l0YOXMaup6ofDqZgrfiO5ZvL8xOGI34bTEfN4BI7VzxwDIIHCfuLwP2CvEyQZ+uJ1GF+dnP9WSXDtow== dmitriy@tadyshev.com"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuTagJos8iCJSStFn0prgZ8bAIzdgkgTHn+G767vVGFVou4u6rNLnkoMawxwEK9d91urN8F/FzVbw5PeJbI9uC65LJlIxwx7Ayo0xh3Jg6HJ9aN+Mtsilb5AZVcYDQLzY7EW6N2wjs772fCessQrqDTFo0/bAYYYPlmny7lFQivjgr2n1DerxecUQdhlCshhIbds5IlkS27nQNfDds3Yo31FnRNYxx+dSghgAaRpPczgfCXjE8HISBpHvKVfboioEcCLnNLYFWSjJRNxLGBSGRqnaIe5viTHh2pE4FvWmZvRa2NOF34QX3p7aU1ViYFlRbS1xvCBtv57gsJgxC/f4sCndOGI+rdhp+mPgp2Y6wzPUqTzaYKQcIS9Xkq9nKNWwytjzOQ0mtcrR0IxORTD1l62EtxnlPZnbQ5dFtU3SYLS5w6W/OIju7+X5E7VJDN172aNcYdas79BgrVWP5bBrY+84Aon8lHgO4xhjmrlzHRIP0aYLKBYpfbSEWhjjIVR0IMY3HrfaX5P80yfo/DCYrQ91smanJI2eYXCMBsuaFgrR5xTNrCCeFbRuo5GjNJYRfi/4LuF3BjU5RFry3AYa7q8dv90o+O8RU1caPCj/B/y21yvVwo40/dH4wy+IIXKwUPoL+i43OXuKdfC9ggkdWekvodaQLg2irGJUp1Mn35w== dmitriy.tadyshev@tachyus.com"
    ];
  };

  users.extraGroups.ditadi = {
    gid = 1000;
  };
}
