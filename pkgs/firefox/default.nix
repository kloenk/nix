{ firefox-unwrapped
, wrapFirefox
, stdenvNoCC
}:

let
  firefoxPolicies = stdenvNoCC.mkDerivation {
    name = "firefox-policies";

    gtk3 = false;

    buildCommand = ''
      mkdir $out
      umask 0022
      cp -r ${firefox-unwrapped}/* $out

      # patch $out/bin/firefox
      chmod +rwx -R $out/bin/
      sed -i 's/exec.*$//' $out/bin/firefox
      echo "exec -a \"$out/bin/.firefox-wrapped\" \"$out/bin/.firefox-wrapped\" \"\$@\"" >> $out/bin/firefox
      
      chmod +rw $out/lib/firefox
      ln -sfT /etc/firefox $out/lib/firefox/distribution
    '';

    meta = firefox-unwrapped.meta;
  };
  firefox-policies-wrapped = wrapFirefox firefoxPolicies { gdkWayland = true; browserName = "firefox"; };
in {
  inherit firefoxPolicies firefox-policies-wrapped;
}
