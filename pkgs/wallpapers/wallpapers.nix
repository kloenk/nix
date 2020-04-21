# Use nix-repl to see the wallpapers available:
# nix repl
# > builtins.attrNames ((builtins.getFlake "nixpkgs").legacyPackages.${builtins.currentSystem}.callPackage ./wallpapers.nix {})
# > builtins.attrNames ((builtins.getFlake "nixpkgs").legacyPackages.${builtins.currentSystem}.callPackage ./wallpapers.nix {}).mobile
# These ones are nsfw, see the warning above
# > builtins.attrNames ((builtins.getFlake "nixpkgs").legacyPackages.${builtins.currentSystem}.callPackage ./wallpapers.nix {}).nsfw
# > builtins.attrNames ((builtins.getFlake "nixpkgs").legacyPackages.${builtins.currentSystem}.callPackage ./wallpapers.nix {}).mobile.nsfw
{ stdenvNoCC, curl, jq, gnused, runCommand, fetchurl }: let
  # TODO somehow parse the src page's output and extract the image out (should be possible!)
  fromPixiv = { url, sha256, src, meta ? {} }: fetchurl {
    inherit url sha256 meta;
    curlOpts = "-H Referer:${src}";
  };
  # This function downloads an image from a reddit post.
  # It is a fixed-output derivation, so don't forget to add the hash!
  fromRedditPost = { name ? if ( if meta ? nsfw then meta.nsfw else false) then ("nsfw-" + (builtins.baseNameOf url)) else (builtins.baseNameOf url), url, sha256, meta ? {} }: runCommand name {
    outputHash = sha256; outputHashAlgo = "sha256"; outputHashMode = "flat"; inherit meta;
  } ''
    # The post ID is always the 5-th component in the comments link
    postid=$(echo "${url}" | ${gnused}/bin/sed -Ee 's;https?://(www.)?reddit.com;;' | cut -d / -f 5 )
    imageUrl=$(${curl}/bin/curl \
      --insecure \
      --user-agent "NixOS:https://gitlab.com/vikanezrimaya/nix-flake:v0.0.0 (by /u/kisik21)" \
      -H "Accept: application/json" \
      "https://www.reddit.com/by_id/t3_''${postid}.json" | ${jq}/bin/jq -r ".data.children[0].data.url")

    ${curl}/bin/curl --insecure $imageUrl > $out
  '';
  nsfw_warning = n: "warning: a NSFW image derivation ${n} is used.\nBy building this, you confirm that you are of age to view lewd anime pictures in your country (usually 18 years old) and that it is legal for you to do so.\nIf you break the law or hurt your feelings, it's your fault - I assume no responsibility for this.";
in {
  nix-wallpaper-stripes-logo = fetchurl {
    # NixOS stripes wallpaper
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/766f10e0c93cb1236a85925a089d861b52ed2905/wallpapers/nix-wallpaper-stripes-logo.png";
    sha256 = "0cqjkgp30428c1yy8s4418k4qz0ycr6fzcg4rdi41wkh5g1hzjnl";
  };
  cubes-pbb = fetchurl {
    url = "https://git.pbb.lc/petabyteboy/nixfiles/raw/branch/master/configuration/desktop/wallpapers/cubes.png";
    sha256 = "9c61d241a53907900bd9e688e5ac347475847c3cd178e32ef7a38c435554286f";
  };
  voyager-pbb = fetchurl {
    url = "https://git.pbb.lc/petabyteboy/nixfiles/raw/branch/master/configuration/desktop/wallpapers/voyager.png";
    sha256 = "da587ba6c1fd0bfc0a2d6d566f1dc0aeb13931a093e45ea1c452a0b10b4d7c2b";
  };
  sao-pbb = fetchurl {
    url = "https://git.pbb.lc/petabyteboy/nixfiles/raw/branch/master/configuration/desktop/wallpapers/sao.png";
    sha256 = "a7d39c5ea5c47cba7db58c304da613b1c8318fbbdb7e190ddb8e3a1248f148ea";
  };
  bioshock_big_dady = fetchurl {
    url = "https://i.imgur.com/63nJZTP.jpg";
    sha256 = "016d7416b0f71c851121d19f145aa4bf8bb03324f21e198cf0d2577a39208864";
  };
  bioshock_cloud_city = fetchurl {
    url = "https://i.imgur.com/6lVYTNy.jpg";
    sha256 = "c843c53ee7600d3883508413da29cd03dfdbdd11f7d6c939b9ee43512a9e7f87";
  };
  pixiv-32056860 = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/32056860";
    url = "https://i.pximg.net/img-master/img/2012/12/12/00/22/50/32056860_p0_master1200.jpg";
    sha256 = "904d0ad62408f3cbc86c2d75a8512e32d0fb2ef914dbb15d911778ad52f4fded";
  };
  pixiv-68126524 = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/68126524";
    url = "https://i.pximg.net/img-original/img/2018/07/19/22/57/08/68126524_p0.jpg";
    sha256 = "0n21v9kzjlgbfib4fzn36zplh41ynpjr6c2inzi72x3l3kksp9a8";
  };
  pixiv-66630837 = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/66630837";
    url = "https://i.pximg.net/img-original/img/2018/01/04/00/00/06/66630837_p0.jpg";
    sha256 = "4f71768be2874d8adcf4aed6c8b54e50e496263de5a742766c5c6abac07d902f";
  };
  pixiv-72175872 = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/72175872";
    url = "https://i.pximg.net/img-original/img/2018/12/19/00/00/04/72175872_p0.jpg";
    sha256 = "aad71cf70c87e51025e11d6c7ab86eb43bc9c005b5d0fe96fb8707d94b173755";
  };
  pixiv-cat = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/73205835";
    url = "https://i.pximg.net/img-master/img/2019/02/16/00/00/03/73205835_p0_master1200.jpg";
    sha256 = "33849724584233d929fa433266b29344522fc8de8186fdce5469448b53e01896";
  };
  pixiv-umbrella = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/73838366";
    url = "https://i.pximg.net/img-master/img/2019/03/24/00/00/01/73838366_p0_master1200.jpg";
    sha256 = "923869c57b92f66639cefe1e8c046a5555d0642f04297d38b194aa67b6c263c9";
  };
  bioshock_anime = fromPixiv {
    src = "https://www.pixiv.net/en/artworks/588905";
    url = "https://i.pximg.net/img-master/img/2008/03/28/13/22/30/588905_p0_master1200.jpg";
    sha256 = "c1cfe1c8aca96794a6e35cc9429fbac5e7d85eb4aa63a7b52e8f492dbeabe214";
  };
  lost_in_space_mag = fromRedditPost {
    url = "https://www.reddit.com/r/WarframeRunway/comments/en4jw5/mag_as_robot_mock_poster_for_lost_in_space_watch/";
    sha256 = "d2e2d7ed923f7e6dcecc6e0ff95769d1cdc76fee9d5069f4ff7b9d74acda20a9";
  };
  tomorrowland = fromRedditPost {
    url = "https://www.reddit.com/r/LargeImages/comments/3zyz6c/2880x1800_tomorrowland_field_and_city_rwallpaper/";
    sha256 = "19cbc8aae6d28eda2bb466e56367adf29d37f446bdc442f26fd0849ab4c4fe9a";
  };
  alita = fromRedditPost {
    url = "https://www.reddit.com/r/LargeImages/comments/fk9fcj/7680x4800_alita_battle_angel_rwallpapers/";
    sha256 = "afd0db7c9a3b5ce4a2b324dff66b3a95b21610bce2d3a47e59a8655ce46de906";
  };
  clouds = fromRedditPost {
    url = "https://www.reddit.com/r/wallpapers/comments/g2e2rh/refulgence_2560_x_1440/";
    sha256 = "0e4436920ae4d9d063614bc83bced0173c71a60870b69fe465865d3549c76094";
  };
  argo_ship = fromRedditPost {
    url = "https://www.reddit.com/r/StarshipPorn/comments/frh9x4/the_argo_taking_off_from_a_remote_moon_in_the/";
    sha256 = "aaf4f0ed16b83d764a0b2ef7b2d5b7ca725214269c8bdb6224402faa32b11a6c";
  };
  city_depths = fromRedditPost {
    url = "https://www.reddit.com/r/wallpapers/comments/g0etum/city_depths_by_alec_tucker_3840x2160/";
    sha256 = "33e7fcb9a239b953ed359084c6c266d0ecc61fe1a84e56192119f7d4b35acbc8";
  };
  bioshock_skycrane = fromRedditPost {
    url = "https://www.reddit.com/r/gaming/comments/87hknr/some_bioshock_wallpapers/";
    sha256 = "7dcb620683f771fae0165e3ecce7ee53bcd95c4e0ed96e7d959773073db2a9ed";
  };
  life_is_strange = fromRedditPost {
    url = "https://www.reddit.com/r/lifeisstrange/comments/50wtfd/beautiful_life_is_strange_wallpapers_ive_been/";
    sha256 = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855";
  };
  life_is_strange_wall = fromRedditPost {
    url = "https://www.reddit.com/r/lifeisstrange/comments/3iimba/youtube_gamings_life_is_strange_background_makes/";
    sha256 = "c2bad8932f71d66b2dfd58fd3bab928b54def9866e529041b1bc611830d2ae3a";
  };
  life_is_strange_beach = fromRedditPost {
    url = "https://www.reddit.com/r/lifeisstrange/comments/4v9uhi/life_is_strange_wallpaper_2k/";
    sha256 = "8556b21581a0ba7c8221d3e648f8b3398d23d6d1645c3ae66fe0c1b2f3ba9199";
  };
  life_is_strange_railway = fromRedditPost {
    url = "https://www.reddit.com/r/Thememyxbox/comments/7my729/can_someone_add_this_to_theme_my_xbox_unless/";
    sha256 = "12caf6fce61e0cdbdb506b8f97158bf9fbb5be6d776e4f5217bfbda6e77b0416";
  };
  cloudy_moments = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/f4uu8i/cloudy_moments_your_name_2560x1440/";
    sha256 = "e3e576c3b20c7c5fd6b21a64a88fb9da238f359234a8be9bb4d04c923cdf0c82";
  };
  one_small_step = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/g253ce/one_small_step_for_man_original_1996x1224/";
    sha256 = "24a2663eee28fe57bebe2e4dba42ddb83c1b9fcb44171a9259eebc124ebe2bc9";
  };
  falling_stone = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/ahkner/your_name_kimi_no_na_wa_7015x3879/";
    sha256 = "e19f25f0ef90f3859465c6abef8717efac0823f80afc614b964dc4950eda8a10";
  };
  go_home = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/fzjd8i/lets_go_home_original_3840x2160/";
    sha256 = "f22e2d45d7625a02eed14ee00597fe4970aa1607ede2fcb56c3bd7b8294e1984";
  };
  angle_beats = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/fzlf1h/kanade_tachibana_angel_beats_1920x1080/";
    sha256 = "8c78918f246bdf94771fd2c62c9c63225856d7bf9c512b6c084640cd2323c76d";
  };
  water_skirt = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/fz9usp/water_skirt_original_2560x1440/";
    sha256 = "103frcg1clyrbhbydjlhvcyp2n0ffkz9hqvy1qx4m7z3if0hszn0";
  };
  kawakaze_azur_lane = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/fyi48d/kawakaze_azur_lane_2560x1440/";
    sha256 = "1kvihs45rjf25hdwj23i669mj8x9flmhlhaf4jv89mzc8gzgxv1y";
  };
  the_remaining_4_minutes = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/fsvzsg/the_remaining_4_minutes_original_2560x1440/";
    sha256 = "12g96pfv8d84hpz1jkdj137acis1qfqbrll2v76mqb3zi69fvlyz";
  };
  lit_fire_angle = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/ftj8br/lit_fire_angle_3840x2160_4k/";
    sha256 = "107kd0lx0bsxcjz5g39080nyahqy00bil0bw48nc2vh9h28f3g1q";
  };
  mikasa_attack_on_titan = fromRedditPost {
    url = "https://www.reddit.com/r/Animewallpaper/comments/fygc1g/mikasa_attack_on_titan_1920x1080/";
    sha256 = "1v02ls8ffp9l8s9vsg5ck59944c0w885c6z3magqnnk083pfn0km";
  };


  # These are mobile wallpapers (for use with future NixOS-on-mobile project maybe?)
  /*mobile = {
    tsunemori_akane_psychopass = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/g00uw7/tsunemori_akane_psychopass_1440x2560/";
      sha256 = "1a8npybl7bcmdbyzpksark1vmzph6nkvbygsy3rj0k7ly6yzhyx1";
    };
    yumeko_jabami_kakegurui = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/fzqp7e/yumeko_jabamikakegurui_2250x4000/";
      sha256 = "0f1a1rav0pvxq8khyxzg4sprnzdhhfn9wlxizqsl8sgvihkvrw7g";
    };
    mordred_fate = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/fz85bx/mordred_fategrand_order_2250x4000/";
      sha256 = "1lp5k3zvnpbpqkj71j5ip0v4bdsm3yi2w2bang8qbga3qsw9xrwj";
    };
    mordred_fate_2 = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/fw12ez/mordred_fategrand_order_2250x4000/";
      sha256 = "1hba7wlj1x14j0fykqzwfpr1m61n58bp96w5c2qaqanrfmsmld6w";
    };
    tifa_lockhart_final_fantasy_vii = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/fz84sh/tifa_lockhart_final_fantasy_vii_2250x4000/";
      sha256 = "0q4xdarc9p68h62imnswhjndcv6bjwq0d8j227y01pq0w6y8d1hb";
    };
    ponytail_a2_nier_automata = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/fwzljv/ponytail_a2_nierautomata_2160x3840/";
      sha256 = "1ymlazyj3m4jd5fpxj99kgcja8lnmgd42wcj82c8k130ypyhn7nj";
    };
    # These are NSFW.
    # By building these derivations, you confirm that you are indeed 18 years or older
    # (or whatever the legal age for viewing lewd stuff in your country is)
    # and you want to see some anime lewd pictures.
    #
    # I am not responsible for possibility of these pictures somehow hurting your feelings
    # or you breaking some laws and possibly being arrested. You have been warned.
    nsfw = builtins.mapAttrs (n: v: builtins.trace (nsfw_warning n) v) {
      yui_ohtsuki_the_idolmaster_cinderella_girls = {
        url = "https://www.reddit.com/r/Animewallpaper/comments/fzzc3i/yui_ohtsuki_the_idolmaster_cinderella_girls/";
        sha256 = "0000000000000000000000000000000000000000000000000000";
        meta.nsfw = true;
      };
      hatsune_miku_vocaloid = {
        url = "https://www.reddit.com/r/Animewallpaper/comments/fyo9oj/hatsune_miku_vocaloid_3375x6000/";
        sha256 = "0000000000000000000000000000000000000000000000000000";
        meta.nsfw = true;
      };
    };
  };*/


  # These are NSFW.
  # By building these derivations, you confirm that you are indeed 18 years or older
  # (or whatever the legal age for viewing lewd stuff in your country is)
  # and you want to see some anime lewd pictures.
  #
  # I am not responsible for possibility of these pictures somehow hurting your feelings.
  # You have been warned.
  nsfw = builtins.mapAttrs (n: v: builtins.trace (nsfw_warning n) v) {
    /*pixiv-79396401 = fromPixiv {
      src = "https://www.pixiv.net/en/artworks/79396401";
      url = "https://i.pximg.net/img-original/img/2020/02/10/15/57/19/79396401_p0.jpg";
      sha256 = "0xip0vkdwx6mcjgsr87myqyqgqf62r7nnsbzhgpgannhmgxv71kf";
      meta.nsfw = true;
    };*/
    /*gremory_rias_highschool_dxd = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/fw6o1w/gemory_rias_highschool_dxd_3840x2160/";
      sha256 = "0a9i88c6q1byyw6gqdv4ylgs73ic11z5yj2q01gvam9azwr8w68p";
      meta.nsfw = true;
    };*/
    danbooru-563552 = fetchurl {
      # Unavailable in Russia without a proxy.
      url = "https://cdn.donmai.us/original/d2/ef/__hatsune_miku_kagamine_rin_and_megurine_luka_vocaloid_drawn_by_ism_inc__d2ef9eccd179ace008029a603eedbd35.jpg";
      sha256 = "0kznwj0b92mfq0d710jb0mpkibi9i2w72h8zialyjm2k7qz0j95z";
      meta.nsfw = true;
    };
    /*rin_tohsaka_fate = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/blvviv/fate_3000x1876/";
      sha256 = "0p8klvsghb3iql4yxnqphwqyhhk847aak1j5h7xsb15w74mp5s82";
      meta.nsfw = true;
    };*/
    holo_spice_and_wolf = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/fxjxmf/holo_spice_and_wolf_1920x1080/";
      sha256 = "1j8idya3a4ay2xjxcz9y7c4x756m65z48j98h24y72s9pnib25hn";
      meta.nsfw = true;
    };
    zero_two_lingerie_franxx = fromRedditPost {
      url = "https://www.reddit.com/r/Animewallpaper/comments/fvtamr/zero_two_lingerie_darling_in_the_franxx_1920x1080/";
      sha256 = "01qmjhffr0jq7wgppjjfgp7g3qk8y8pihsyzjjabnl4ppli0449i";
      meta.nsfw = true;
    };
  };
}
