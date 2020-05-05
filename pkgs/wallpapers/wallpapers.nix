# Inspired by vika (/u/kisik21) https://gitlab.com/vikanezrimaya/nix-flake
{ stdenvNoCC, curl, jq, gnused, runCommand, fetchurl }:

let
  n = name: v:
    builtins.trace ''
      warning: a NSFW image derivation ${name} is used.
      By building this, you confirm that you are of age to view lewd anime pictures in your country (usually 18 years old) and that it is legal for you to do so.
      If you break the law or hurt your feelings, it's your fault - I assume no responsibility for this.
    '' v;

  fromPixiv = { name ? builtins.baseNameOf url, url, sha256, src, meta ? { } }:
    runCommand name {
      outputHash = sha256;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    } ''
      dir=$out/share/wallpapers/${
        if (if meta ? nsfw then meta.nsfw else false) then
          n name "nsfw/"
        else
          ""
      }/

      mkdir -p $dir
      ${curl}/bin/curl --insecure -H Referer:${src} ${url} > $dir/${name}
    '';

  fromRedditPost = { name ? if (if meta ? nsfw then meta.nsfw else false) then
    ("nsfw-" + (builtins.baseNameOf url))
  else
    (builtins.baseNameOf url), url, sha256, meta ? { } }:
    runCommand name {
      outputHash = sha256;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
      inherit meta;
    } ''
      # The post ID is always the 5-th component in the comments link
      postid=$(echo "${url}" | ${gnused}/bin/sed -Ee 's;https?://(www.)?reddit.com;;' | cut -d / -f 5 )
      imageUrl=$(${curl}/bin/curl \
        --insecure \
        --user-agent "NixOS/20.09" \
        -H "Accept: application/json" \
        "https://www.reddit.com/by_id/t3_''${postid}.json" | ${jq}/bin/jq -r ".data.children[0].data.url")

      dir=$out/share/wallpapers/${
        if (if meta ? nsfw then meta.nsfw else false) then
          n name "nsfw/"
        else
          ""
      }/

      mkdir -p $dir
      ${curl}/bin/curl --insecure $imageUrl > $dir/${name}
    '';

in {
  pixiv_city = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/32056860";
    url =
      "https://i.pximg.net/img-master/img/2012/12/12/00/22/50/32056860_p0_master1200.jpg";
    sha256 = "bd146ed7570c2b5998af204fa591be1292699ede67af7133b2dffb2abc4e2380";
  };

  pixiv_orange = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/68126524";
    url =
      "https://i.pximg.net/img-original/img/2018/07/19/22/57/08/68126524_p0.jpg";
    sha256 = "b92c6e3a0e48508a88a34d9de58f87ce21ccbacecef0c2e9e5b317daa7cdf630";
  };

  pixiv-72175872 = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/72175872";
    url =
      "https://i.pximg.net/img-original/img/2018/12/19/00/00/04/72175872_p0.jpg";
    sha256 = "6ec54efc53febfe1fca8614ba226f8f3076fb0aa2c425fc5b8f3acf75760276a";
  };

  pixiv-cat = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/73205835";
    url =
      "https://i.pximg.net/img-master/img/2019/02/16/00/00/03/73205835_p0_master1200.jpg";
    sha256 = "2a630f4d0081fe4f966746b875480df5997c4be40ba30d8c44dfc0db00faa0b7";
  };

  pixiv-umbrella = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/73838366";
    url =
      "https://i.pximg.net/img-master/img/2019/03/24/00/00/01/73838366_p0_master1200.jpg";
    sha256 = "1714ad420ab21a0a08d1ed6ef9d769235e1f807bf2107a33b2382f74bd3eeeaf";
  };

  pixiv_bioshock_anime = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/588905";
    url =
      "https://i.pximg.net/img-master/img/2008/03/28/13/22/30/588905_p0_master1200.jpg";
    sha256 = "e2289c25bdee0f2a4cb2579c78169db12dc608255c706b740e480ccf5d25df40";
  };

  lost_in_space_mag = fromRedditPost {
    url =
      "//www.reddit.com/r/WarframeRunway/comments/en4jw5/mag_as_robot_mock_poster_for_lost_in_space_watch/";
    sha256 = "86373553fb2966970275a80fae27dadb4d846a1fcdeab6e76109abb2afcc6df9";
  };
}
