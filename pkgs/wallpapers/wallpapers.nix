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

  fromUrl = { name ? builtins.baseNameOf url, url, sha256, meta ? { } }:
    runCommand name {
      outputHash = sha256;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    } ''
      dir=$out/share/wallpapers/${if (if meta ? nsfw then meta.nsfw else false) then n name "nsfw/" else ""}/

      mkdir -p $dir
      ${curl}/bin/curl --insecure ${url} > $dir/${name}
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

  cubes-pbb = fromUrl {
    url =
       "https://git.pbb.lc/petabyteboy/nixfiles/raw/branch/master/configuration/desktop/wallpapers/cubes.png";
    sha256 = "sha256-x/2eGoFsuSq/y+LzYiKXETFjiNztR7J0RrjLbHm3MOk=";
  };

  sao-pbb = fromUrl {
    url = "https://git.pbb.lc/petabyteboy/nixfiles/raw/branch/master/configuration/desktop/wallpapers/sao.png";
    sha256 = "sha256-+vhxAzIY+T52zZsfxGpA3cBwVSr0eEgCS2liRhRmayM=";
  };

  bioshok_big_dady = fromUrl {
    url = "https://i.imgur.com/63nJZTP.jpg";
    sha256 = "sha256-2LucvG3c7qR++0YmQMCp1bzTW6Ta9ezUswOkndBmGlw=";
  };

  bioshock_cloud_city = fromUrl {
    url = "https://i.imgur.com/6lVYTNy.jpg";
    sha256 = "sha256-SQuwq0mZSKRG/1V9h4HCPyuVDOpCfrCp4UZkzajo3+U=";
  };

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
      "https://www.reddit.com/r/WarframeRunway/comments/en4jw5/mag_as_robot_mock_poster_for_lost_in_space_watch/";
    sha256 = "sha256-MJ4OCmiZxvzh0KOwtzjwvPGtoAsCLTy6CqiK2ff28Zw=";
  };

  tomorrowland = fromRedditPost {
    url = "https://www.reddit.com/r/LargeImages/comments/3zyz6c/2880x1800_tomorrowland_field_and_city_rwallpaper/";

    sha256 = "sha256-SikIuI3F+10S/dfm8dwMAsZmQIw4I0FlfEV/xVWA4nk=";
  };

  alita = fromRedditPost {
    url = "https://www.reddit.com/r/LargeImages/comments/fk9fcj/7680x4800_alita_battle_angel_rwallpapers/";
    sha256 = "sha256-XYwlqRxJcsLJi/WL/qIseYDkJfKXYofIdC/CE0Hv12U=";
  };

  clouds = fromRedditPost {
    url = "https://www.reddit.com/r/wallpapers/comments/g2e2rh/refulgence_2560_x_1440/";
    sha256 = "sha256-MBCsGrSajqJfQB7V7B7zVhH2/SvX98hRq9sL0fOgCV4=";
  };

  argo_ship = fromRedditPost {
    url = "https://www.reddit.com/r/StarshipPorn/comments/frh9x4/the_argo_taking_off_from_a_remote_moon_in_the/";
    sha256 = "sha256-lffXq7MJVmbOZj2PG1oKyuR2/4xeTh1+BikRg0yeUMc=";
  };

  city_depth = fromRedditPost {
    url = "https://www.reddit.com/r/wallpapers/comments/g0etum/city_depths_by_alec_tucker_3840x2160/";
    sha256 = "sha256-KpBR/QUtxVuhY2rQSnkryQOBIt2uvoaXoVMeXf3NKN4=";
  };

  bioshock_skycrane = fromRedditPost {
    url = "https://www.reddit.com/r/gaming/comments/87hknr/some_bioshock_wallpapers/";
    sha256 = "sha256-fHJf+XCsSIGscBKTnd05yhceBjZINMJsGgWAD0xsoLs=";
  };

  life_is_strange = fromRedditPost {
    url =
      "https://www.reddit.com/r/lifeisstrange/comments/50wtfd/beautiful_life_is_strange_wallpapers_ive_been/";
    sha256 = "sha256-QSoagU1hk+au9ztLNmXYeY/W93ccxowWDyNPri8/D6M=";
  };
  life_is_strange_wall = fromRedditPost {
    url =
      "https://www.reddit.com/r/lifeisstrange/comments/3iimba/youtube_gamings_life_is_strange_background_makes/";
    sha256 = "sha256-RaNCMrWSCV8hwhch47bewJmBGNedrdbIuBOzgRRxHf0=";
  };
  life_is_strange_beach = fromRedditPost {
    url =
      "https://www.reddit.com/r/lifeisstrange/comments/4v9uhi/life_is_strange_wallpaper_2k/";
    sha256 = "sha256-c3f78mEPyvIQHf/6hednJ0bJj5X5yKJh4KYaxgjkiw4=";
  };
  life_is_strange_railway = fromRedditPost {
    name = "life_is_strange_railway";
    url =
      "https://www.reddit.com/r/Thememyxbox/comments/7my729/can_someone_add_this_to_theme_my_xbox_unless/";
    sha256 = "sha256-ZrriNKePp37sel7RGwFO64In9NzNjXIYOlP7MwBkJRc=";
  };
  cloudy_moments = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/f4uu8i/cloudy_moments_your_name_2560x1440/";
    sha256 = "sha256-bP3j3qUsH4sWPE15XZfS4H/6YqadjN2N66ofo7Y/BgA=";
  };
  one_small_step = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/g253ce/one_small_step_for_man_original_1996x1224/";
    sha256 = "sha256-IXzGOtU21e1EMD84xjqbJtegQp6LuYYmV0p8vH6TDac=";
  };
  falling_stone = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/ahkner/your_name_kimi_no_na_wa_7015x3879/";
    sha256 = "sha256-pi2YmPO2NlooA3lq+UfBNP5VI9ik1uzyBKLj0UKXmFU=";
  };
  go_home = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/fzjd8i/lets_go_home_original_3840x2160/";
    sha256 = "sha256-Gtvp2RW9okF6cx+0jp+FSFpsTYkliNhBF7J+kp56ZnQ=";
  };
  angle_beats = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/fzlf1h/kanade_tachibana_angel_beats_1920x1080/";
    sha256 = "sha256-Ltx++8TKBRfM+FVnwBdVYOZ+jYv7f8goIxTO4dj56pg=";
  };
  water_skirt = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/fz9usp/water_skirt_original_2560x1440/";
    sha256 = "sha256-XKsOBn+8V6eaXmsTxyR0XlLXfc4zWQrtWF3oVs7YK4k=";
  };
  kawakaze_azur_lane = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/fyi48d/kawakaze_azur_lane_2560x1440/";
    sha256 = "sha256-vOEBEtGS7C482i9ONjFLtNTh1sG2Zq//MmjocIAW+kw=";
  };
  the_remaining_4_minutes = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/fsvzsg/the_remaining_4_minutes_original_2560x1440/";
    sha256 = "sha256-GspttvJlK2lZ/dFapic0mKeBI+MnhxUz6VZ9qpgEIvU=";
  };
  lit_fire_angle = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/ftj8br/lit_fire_angle_3840x2160_4k/";
    sha256 = "sha256-Zzy3WrzYiRmmkbD1FSCV2vG0EQmYWRKrQdWcTU7AiGU=";
  };
  mikasa_attack_on_titan = fromRedditPost {
    url =
      "https://www.reddit.com/r/Animewallpaper/comments/fygc1g/mikasa_attack_on_titan_1920x1080/";
    sha256 = "sha256-EoQBODhsFii7YNHuKHciW7fIIW5ui9EBMrKeYtPJ7Io=";
  };
}
