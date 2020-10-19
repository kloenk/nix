{
  plug_crypto = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "bdd187572cc26dbd95b87136290425f2b580a116d3fb1f564216918c9730d227";
      url = "https://repo.hex.pm/tarballs/plug_crypto-1.1.2.tar";
    };
    version = "1.1.2";
  };
  deep_merge = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "b4aa1a0d1acac393bdf38b2291af38cb1d4a52806cf7a4906f718e1feb5ee961";
      url = "https://repo.hex.pm/tarballs/deep_merge-1.0.0.tar";
    };
    version = "1.0.0";
  };
  parse_trans = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "09765507a3c7590a784615cfd421d101aec25098d50b89d7aa1d66646bc571c1";
      url = "https://repo.hex.pm/tarballs/parse_trans-3.3.0.tar";
    };
    version = "3.3.0";
  };
  flake_id = {
    builder = "mix";
    deps = [ "base62" "ecto" ];
    fetchHex = {
      sha256 =
        "7716b086d2e405d09b647121a166498a0d93d1a623bead243e1f74216079ccb3";
      url = "https://repo.hex.pm/tarballs/flake_id-0.1.0.tar";
    };
    version = "0.1.0";
  };
  bcrypt_elixir = {
    builder = "mix";
    deps = [ "comeonin" "elixir_make" ];
    fetchHex = {
      sha256 =
        "3df902b81ce7fa8867a2ae30d20a1da6877a2c056bfb116fd0bc8a5f0190cea4";
      url = "https://repo.hex.pm/tarballs/bcrypt_elixir-2.2.0.tar";
    };
    version = "2.2.0";
  };
  syslog = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "6419a232bea84f07b56dc575225007ffe34d9fdc91abe6f1b2f254fd71d8efc2";
      url = "https://repo.hex.pm/tarballs/syslog-1.1.0.tar";
    };
    version = "1.1.0";
  };
  plug = {
    builder = "mix";
    deps = [ "mime" "plug_crypto" "telemetry" ];
    fetchHex = {
      sha256 =
        "41eba7d1a2d671faaf531fa867645bd5a3dce0957d8e2a3f398ccff7d2ef017f";
      url = "https://repo.hex.pm/tarballs/plug-1.10.4.tar";
    };
    version = "1.10.4";
  };
  bbcode = {
    builder = "mix";
    fetchGit = {
      rev = "f2d267675e9a7e1ad1ea9beb4cc23382762b66c2";
      url = "https://git.pleroma.social/pleroma/elixir-libraries/bbcode.git";
    };
    version = "f2d267675e9a7e1ad1ea9beb4cc23382762b66c2";
  };
  libring = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "41246ba2f3fbc76b3971f6bce83119dfec1eee17e977a48d8a9cfaaf58c2a8d6";
      url = "https://repo.hex.pm/tarballs/libring-1.4.0.tar";
    };
    version = "1.4.0";
  };
  base64url = {
    builder = "rebar";
    fetchHex = {
      sha256 =
        "36a90125f5948e3afd7be97662a1504b934dd5dac78451ca6e9abf85a10286be";
      url = "https://repo.hex.pm/tarballs/base64url-0.0.1.tar";
    };
    version = "0.0.1";
  };
  castore = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "1ca19eee705cde48c9e809e37fdd0730510752cc397745e550f6065a56a701e9";
      url = "https://repo.hex.pm/tarballs/castore-0.1.7.tar";
    };
    version = "0.1.7";
  };
  fast_sanitize = {
    builder = "mix";
    deps = [ "fast_html" "plug" ];
    fetchHex = {
      sha256 =
        "3cbbaebaea6043865dfb5b4ecb0f1af066ad410a51470e353714b10c42007b81";
      url = "https://repo.hex.pm/tarballs/fast_sanitize-0.2.2.tar";
    };
    version = "0.2.2";
  };
  nimble_pool = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "ffa9d5be27eee2b00b0c634eb649aa27f97b39186fec3c493716c2a33e784ec6";
      url = "https://repo.hex.pm/tarballs/nimble_pool-0.1.0.tar";
    };
    version = "0.1.0";
  };
  excoveralls = {
    builder = "mix";
    deps = [ "hackney" "jason" ];
    fetchHex = {
      sha256 =
        "2142be7cb978a3ae78385487edda6d1aff0e482ffc6123877bb7270a8ffbcfe0";
      url = "https://repo.hex.pm/tarballs/excoveralls-0.12.3.tar";
    };
    version = "0.12.3";
  };
  earmark = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "364ca2e9710f6bff494117dbbd53880d84bebb692dafc3a78eb50aa3183f2bfd";
      url = "https://repo.hex.pm/tarballs/earmark-1.4.3.tar";
    };
    version = "1.4.3";
  };
  base62 = {
    builder = "mix";
    deps = [ "custom_base" ];
    fetchHex = {
      sha256 =
        "4866763e08555a7b3917064e9eef9194c41667276c51b59de2bc42c6ea65f806";
      url = "https://repo.hex.pm/tarballs/base62-1.2.1.tar";
    };
    version = "1.2.1";
  };
  phoenix_html = {
    builder = "mix";
    deps = [ "plug" ];
    fetchHex = {
      sha256 =
        "b8a3899a72050f3f48a36430da507dd99caf0ac2d06c77529b1646964f3d563e";
      url = "https://repo.hex.pm/tarballs/phoenix_html-2.14.2.tar";
    };
    version = "2.14.2";
  };
  crontab = {
    builder = "mix";
    deps = [ "ecto" ];
    fetchHex = {
      sha256 =
        "2ce0e74777dfcadb28a1debbea707e58b879e6aa0ffbf9c9bb540887bce43617";
      url = "https://repo.hex.pm/tarballs/crontab-1.1.8.tar";
    };
    version = "1.1.8";
  };
  mox = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "55a0a5ba9ccc671518d068c8dddd20eeb436909ea79d1799e2209df7eaa98b6c";
      url = "https://repo.hex.pm/tarballs/mox-0.5.2.tar";
    };
    version = "0.5.2";
  };
  jason = {
    builder = "mix";
    deps = [ "decimal" ];
    fetchHex = {
      sha256 =
        "12b22825e22f468c02eb3e4b9985f3d0cb8dc40b9bd704730efa11abd2708c44";
      url = "https://repo.hex.pm/tarballs/jason-1.2.1.tar";
    };
    version = "1.2.1";
  };
  certifi = {
    builder = "rebar3";
    deps = [ "parse_trans" ];
    fetchHex = {
      sha256 =
        "867ce347f7c7d78563450a18a6a28a8090331e77fa02380b4a21962a65d36ee5";
      url = "https://repo.hex.pm/tarballs/certifi-2.5.1.tar";
    };
    version = "2.5.1";
  };
  poolboy = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "392b007a1693a64540cead79830443abf5762f5d30cf50bc95cb2c1aaafa006b";
      url = "https://repo.hex.pm/tarballs/poolboy-1.5.2.tar";
    };
    version = "1.5.2";
  };
  phoenix = {
    builder = "mix";
    deps = [ "jason" "phoenix_pubsub" "plug" "plug_cowboy" "telemetry" ];
    fetchHex = {
      sha256 =
        "1b1bd4cff7cfc87c94deaa7d60dd8c22e04368ab95499483c50640ef3bd838d8";
      url = "https://repo.hex.pm/tarballs/phoenix-1.4.17.tar";
    };
    version = "1.4.17";
  };
  decimal = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "a4ef3f5f3428bdbc0d35374029ffcf4ede8533536fa79896dd450168d9acdf3c";
      url = "https://repo.hex.pm/tarballs/decimal-1.8.1.tar";
    };
    version = "1.8.1";
  };
  prometheus_phoenix = {
    builder = "mix";
    deps = [ "phoenix" "prometheus_ex" ];
    fetchHex = {
      sha256 =
        "c4b527e0b3a9ef1af26bdcfbfad3998f37795b9185d475ca610fe4388fdd3bb5";
      url = "https://repo.hex.pm/tarballs/prometheus_phoenix-1.3.0.tar";
    };
    version = "1.3.0";
  };
  ecto_enum = {
    builder = "mix";
    deps = [ "ecto" "ecto_sql" "postgrex" ];
    fetchHex = {
      sha256 =
        "d14b00e04b974afc69c251632d1e49594d899067ee2b376277efd8233027aec8";
      url = "https://repo.hex.pm/tarballs/ecto_enum-1.4.0.tar";
    };
    version = "1.4.0";
  };
  cachex = {
    builder = "mix";
    deps = [ "eternal" "jumper" "sleeplocks" "unsafe" ];
    fetchHex = {
      sha256 =
        "a596476c781b0646e6cb5cd9751af2e2974c3e0d5498a8cab71807618b74fe2f";
      url = "https://repo.hex.pm/tarballs/cachex-3.2.0.tar";
    };
    version = "3.2.0";
  };
  gen_state_machine = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "9ac15ec6e66acac994cc442dcc2c6f9796cf380ec4b08267223014be1c728a95";
      url = "https://repo.hex.pm/tarballs/gen_state_machine-2.0.5.tar";
    };
    version = "2.0.5";
  };
  joken = {
    builder = "mix";
    deps = [ "jose" ];
    fetchHex = {
      sha256 =
        "2daa1b12be05184aff7b5ace1d43ca1f81345962285fff3f88db74927c954d3a";
      url = "https://repo.hex.pm/tarballs/joken-2.2.0.tar";
    };
    version = "2.2.0";
  };
  pbkdf2_elixir = {
    builder = "mix";
    deps = [ "comeonin" ];
    fetchHex = {
      sha256 =
        "9cbe354b58121075bd20eb83076900a3832324b7dd171a6895fab57b6bb2752c";
      url = "https://repo.hex.pm/tarballs/pbkdf2_elixir-1.2.1.tar";
    };
    version = "1.2.1";
  };
  bbcode_pleroma = {
    builder = "mix";
    deps = [ "nimble_parsec" ];
    fetchHex = {
      sha256 =
        "d36f5bca6e2f62261c45be30fa9b92725c0655ad45c99025cb1c3e28e25803ef";
      url = "https://repo.hex.pm/tarballs/bbcode_pleroma-0.2.0.tar";
    };
    version = "0.2.0";
  };
  tzdata = {
    builder = "mix";
    deps = [ "hackney" ];
    fetchHex = {
      sha256 =
        "73470ad29dde46e350c60a66e6b360d3b99d2d18b74c4c349dbebbc27a09a3eb";
      url = "https://repo.hex.pm/tarballs/tzdata-1.0.3.tar";
    };
    version = "1.0.3";
  };
  prometheus_ecto = {
    builder = "mix";
    deps = [ "ecto" "prometheus_ex" ];
    fetchHex = {
      sha256 =
        "3dd4da1812b8e0dbee81ea58bb3b62ed7588f2eae0c9e97e434c46807ff82311";
      url = "https://repo.hex.pm/tarballs/prometheus_ecto-1.4.3.tar";
    };
    version = "1.4.3";
  };
  plug_cowboy = {
    builder = "mix";
    deps = [ "cowboy" "plug" "telemetry" ];
    fetchHex = {
      sha256 =
        "149a50e05cb73c12aad6506a371cd75750c0b19a32f81866e1a323dda9e0e99d";
      url = "https://repo.hex.pm/tarballs/plug_cowboy-2.3.0.tar";
    };
    version = "2.3.0";
  };
  phoenix_pubsub = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "496c303bdf1b2e98a9d26e89af5bba3ab487ba3a3735f74bf1f4064d2a845a3e";
      url = "https://repo.hex.pm/tarballs/phoenix_pubsub-1.1.2.tar";
    };
    version = "1.1.2";
  };
  timex = {
    builder = "mix";
    deps = [ "combine" "gettext" "tzdata" ];
    fetchHex = {
      sha256 =
        "845cdeb6119e2fef10751c0b247b6c59d86d78554c83f78db612e3290f819bc2";
      url = "https://repo.hex.pm/tarballs/timex-3.6.2.tar";
    };
    version = "3.6.2";
  };
  cowboy = {
    builder = "rebar3";
    deps = [ "cowlib" "ranch" ];
    fetchHex = {
      sha256 =
        "f3dc62e35797ecd9ac1b50db74611193c29815401e53bac9a5c0577bd7bc667d";
      url = "https://repo.hex.pm/tarballs/cowboy-2.8.0.tar";
    };
    version = "2.8.0";
  };
  ex_doc = {
    builder = "mix";
    deps = [ "earmark_parser" "makeup_elixir" ];
    fetchHex = {
      sha256 =
        "03a2a58bdd2ba0d83d004507c4ee113b9c521956938298eba16e55cc4aba4a6c";
      url = "https://repo.hex.pm/tarballs/ex_doc-0.22.2.tar";
    };
    version = "0.22.2";
  };
  ex_machina = {
    builder = "mix";
    deps = [ "ecto" "ecto_sql" ];
    fetchHex = {
      sha256 =
        "09a34c5d371bfb5f78399029194a8ff67aff340ebe8ba19040181af35315eabb";
      url = "https://repo.hex.pm/tarballs/ex_machina-2.4.0.tar";
    };
    version = "2.4.0";
  };
  web_push_encryption = {
    builder = "mix";
    deps = [ "httpoison" "jose" ];
    fetchHex = {
      sha256 =
        "598b5135e696fd1404dc8d0d7c0fa2c027244a4e5d5e5a98ba267f14fdeaabc8";
      url = "https://repo.hex.pm/tarballs/web_push_encryption-0.3.0.tar";
    };
    version = "0.3.0";
  };
  websocket_client = {
    builder = "mix";
    fetchGit = {
      rev = "9a6f65d05ebf2725d62fb19262b21f1805a59fbf";
      url = "https://github.com/jeremyong/websocket_client.git";
    };
    version = "9a6f65d05ebf2725d62fb19262b21f1805a59fbf";
  };
  cowlib = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "61a6c7c50cf07fdd24b2f45b89500bb93b6686579b069a89f88cb211e1125c78";
      url = "https://repo.hex.pm/tarballs/cowlib-2.9.1.tar";
    };
    version = "2.9.1";
  };
  sweet_xml = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "fc3e91ec5dd7c787b6195757fbcf0abc670cee1e4172687b45183032221b66b8";
      url = "https://repo.hex.pm/tarballs/sweet_xml-0.6.6.tar";
    };
    version = "0.6.6";
  };
  unicode_util_compat = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "d869e4c68901dd9531385bb0c8c40444ebf624e60b6962d95952775cac5e90cd";
      url = "https://repo.hex.pm/tarballs/unicode_util_compat-0.4.1.tar";
    };
    version = "0.4.1";
  };
  esshd = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "d4dd4c46698093a40a56afecce8a46e246eb35463c457c246dacba2e056f31b5";
      url = "https://repo.hex.pm/tarballs/esshd-0.1.1.tar";
    };
    version = "0.1.1";
  };
  ex_aws = {
    builder = "mix";
    deps = [ "hackney" "jason" "sweet_xml" ];
    fetchHex = {
      sha256 =
        "26b6f036f0127548706aade4a509978fc7c26bd5334b004fba9bfe2687a525df";
      url = "https://repo.hex.pm/tarballs/ex_aws-2.1.3.tar";
    };
    version = "2.1.3";
  };
  connection = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "a1cae72211f0eef17705aaededacac3eb30e6625b04a6117c1b2db6ace7d5976";
      url = "https://repo.hex.pm/tarballs/connection-1.0.4.tar";
    };
    version = "1.0.4";
  };
  ranch = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "6b1fab51b49196860b733a49c07604465a47bdb78aa10c1c16a3d199f7f8c881";
      url = "https://repo.hex.pm/tarballs/ranch-1.7.1.tar";
    };
    version = "1.7.1";
  };
  telemetry = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "2808c992455e08d6177322f14d3bdb6b625fbcfd233a73505870d8738a2f4599";
      url = "https://repo.hex.pm/tarballs/telemetry-0.4.2.tar";
    };
    version = "0.4.2";
  };
  prometheus = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "20510f381db1ccab818b4cf2fac5fa6ab5cc91bc364a154399901c001465f46f";
      url = "https://repo.hex.pm/tarballs/prometheus-4.6.0.tar";
    };
    version = "4.6.0";
  };
  combine = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "eff8224eeb56498a2af13011d142c5e7997a80c8f5b97c499f84c841032e429f";
      url = "https://repo.hex.pm/tarballs/combine-0.10.0.tar";
    };
    version = "0.10.0";
  };
  poison = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "d9eb636610e096f86f25d9a46f35a9facac35609a7591b3be3326e99a0484665";
      url = "https://repo.hex.pm/tarballs/poison-3.1.0.tar";
    };
    version = "3.1.0";
  };
  pot = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "61bad869a94534739dd4614a25a619bc5c47b9970e9a0ea5bef4628036fc7a16";
      url = "https://repo.hex.pm/tarballs/pot-0.11.0.tar";
    };
    version = "0.11.0";
  };
  calendar = {
    builder = "mix";
    deps = [ "tzdata" ];
    fetchHex = {
      sha256 =
        "f52073a708528482ec33d0a171954ca610fe2bd28f1e871f247dc7f1565fa807";
      url = "https://repo.hex.pm/tarballs/calendar-1.0.0.tar";
    };
    version = "1.0.0";
  };
  unsafe = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "a27e1874f72ee49312e0a9ec2e0b27924214a05e3ddac90e91727bc76f8613d8";
      url = "https://repo.hex.pm/tarballs/unsafe-1.0.1.tar";
    };
    version = "1.0.1";
  };
  phoenix_ecto = {
    builder = "mix";
    deps = [ "ecto" "phoenix_html" "plug" ];
    fetchHex = {
      sha256 =
        "a044d0756d0464c5a541b4a0bf4bcaf89bffcaf92468862408290682c73ae50d";
      url = "https://repo.hex.pm/tarballs/phoenix_ecto-4.1.0.tar";
    };
    version = "4.1.0";
  };
  sleeplocks = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "3d462a0639a6ef36cc75d6038b7393ae537ab394641beb59830a1b8271faeed3";
      url = "https://repo.hex.pm/tarballs/sleeplocks-1.1.1.tar";
    };
    version = "1.1.1";
  };
  bunt = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "951c6e801e8b1d2cbe58ebbd3e616a869061ddadcc4863d0a2182541acae9a38";
      url = "https://repo.hex.pm/tarballs/bunt-0.2.0.tar";
    };
    version = "0.2.0";
  };
  open_api_spex = {
    builder = "mix";
    fetchGit = {
      rev = "f296ac0924ba3cf79c7a588c4c252889df4c2edd";
      url =
        "https://git.pleroma.social/pleroma/elixir-libraries/open_api_spex.git";
    };
    version = "f296ac0924ba3cf79c7a588c4c252889df4c2edd";
  };
  gen_stage = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "d0c66f1c87faa301c1a85a809a3ee9097a4264b2edf7644bf5c123237ef732bf";
      url = "https://repo.hex.pm/tarballs/gen_stage-0.14.3.tar";
    };
    version = "0.14.3";
  };
  cors_plug = {
    builder = "mix";
    deps = [ "plug" ];
    fetchHex = {
      sha256 =
        "2b46083af45e4bc79632bd951550509395935d3e7973275b2b743bd63cc942ce";
      url = "https://repo.hex.pm/tarballs/cors_plug-2.0.2.tar";
    };
    version = "2.0.2";
  };
  plug_static_index_html = {
    builder = "mix";
    deps = [ "plug" ];
    fetchHex = {
      sha256 =
        "840123d4d3975585133485ea86af73cb2600afd7f2a976f9f5fd8b3808e636a0";
      url = "https://repo.hex.pm/tarballs/plug_static_index_html-1.0.0.tar";
    };
    version = "1.0.0";
  };
  custom_base = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "4a832a42ea0552299d81652aa0b1f775d462175293e99dfbe4d7dbaab785a706";
      url = "https://repo.hex.pm/tarballs/custom_base-0.2.1.tar";
    };
    version = "0.2.1";
  };
  mock = {
    builder = "mix";
    deps = [ "meck" ];
    fetchHex = {
      sha256 =
        "feb81f52b8dcf0a0d65001d2fec459f6b6a8c22562d94a965862f6cc066b5431";
      url = "https://repo.hex.pm/tarballs/mock-0.3.5.tar";
    };
    version = "0.3.5";
  };
  hackney = {
    builder = "rebar3";
    deps = [ "certifi" "idna" "metrics" "mimerl" "ssl_verify_fun" ];
    fetchHex = {
      sha256 =
        "07e33c794f8f8964ee86cebec1a8ed88db5070e52e904b8f12209773c1036085";
      url = "https://repo.hex.pm/tarballs/hackney-1.15.2.tar";
    };
    version = "1.15.2";
  };
  nodex = {
    builder = "mix";
    fetchGit = {
      rev = "cb6730f943cfc6aad674c92161be23a8411f15d1";
      url = "https://git.pleroma.social/pleroma/nodex";
    };
    version = "cb6730f943cfc6aad674c92161be23a8411f15d1";
  };
  gettext = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "406d6b9e0e3278162c2ae1de0a60270452c553536772167e2d701f028116f870";
      url = "https://repo.hex.pm/tarballs/gettext-0.18.0.tar";
    };
    version = "0.18.0";
  };
  ssl_verify_fun = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "6eaf7ad16cb568bb01753dbbd7a95ff8b91c7979482b95f38443fe2c8852a79b";
      url = "https://repo.hex.pm/tarballs/ssl_verify_fun-1.1.5.tar";
    };
    version = "1.1.5";
  };
  elixir_make = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "38349f3e29aff4864352084fc736fa7fa0f2995a819a737554f7ebd28b85aaab";
      url = "https://repo.hex.pm/tarballs/elixir_make-0.6.0.tar";
    };
    version = "0.6.0";
  };
  prometheus_ex = {
    builder = "mix";
    deps = [ "prometheus" ];
    fetchHex = {
      sha256 =
        "fa58cfd983487fc5ead331e9a3e0aa622c67232b3ec71710ced122c4c453a02f";
      url = "https://repo.hex.pm/tarballs/prometheus_ex-3.0.5.tar";
    };
    version = "3.0.5";
  };
  html_sanitize_ex = {
    builder = "mix";
    deps = [ "mochiweb" ];
    fetchHex = {
      sha256 =
        "f005ad692b717691203f940c686208aa3d8ffd9dd4bb3699240096a51fa9564e";
      url = "https://repo.hex.pm/tarballs/html_sanitize_ex-1.3.0.tar";
    };
    version = "1.3.0";
  };
  phoenix_swoosh = {
    builder = "mix";
    deps = [ "hackney" "phoenix" "phoenix_html" "swoosh" ];
    fetchHex = {
      sha256 =
        "2acfa0db038a7649e0a4614eee970e6ed9a39d191ccd79a03583b51d0da98165";
      url = "https://repo.hex.pm/tarballs/phoenix_swoosh-0.3.0.tar";
    };
    version = "0.3.0";
  };
  postgrex = {
    builder = "mix";
    deps = [ "connection" "db_connection" "decimal" "jason" ];
    fetchHex = {
      sha256 =
        "aec40306a622d459b01bff890fa42f1430dac61593b122754144ad9033a2152f";
      url = "https://repo.hex.pm/tarballs/postgrex-0.15.5.tar";
    };
    version = "0.15.5";
  };
  mime = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "5066f14944b470286146047d2f73518cf5cca82f8e4815cf35d196b58cf07c47";
      url = "https://repo.hex.pm/tarballs/mime-1.4.0.tar";
    };
    version = "1.4.0";
  };
  ex_syslogger = {
    builder = "mix";
    deps = [ "poison" "syslog" ];
    fetchHex = {
      sha256 =
        "72b6aa2d47a236e999171f2e1ec18698740f40af0bd02c8c650bf5f1fd1bac79";
      url = "https://repo.hex.pm/tarballs/ex_syslogger-1.5.2.tar";
    };
    version = "1.5.2";
  };
  myhtmlex = {
    builder = "mix";
    fetchGit = {
      rev = "ad0097e2f61d4953bfef20fb6abddf23b87111e6";
      url = "https://git.pleroma.social/pleroma/myhtmlex.git";
    };
    version = "ad0097e2f61d4953bfef20fb6abddf23b87111e6";
  };
  metrics = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "25f094dea2cda98213cecc3aeff09e940299d950904393b2a29d191c346a8486";
      url = "https://repo.hex.pm/tarballs/metrics-1.0.1.tar";
    };
    version = "1.0.1";
  };
  gun = {
    builder = "mix";
    fetchGit = {
      rev = "921c47146b2d9567eac7e9a4d2ccc60fffd4f327";
      url = "https://github.com/ninenines/gun.git";
    };
    version = "921c47146b2d9567eac7e9a4d2ccc60fffd4f327";
  };
  captcha = {
    builder = "mix";
    fetchGit = {
      rev = "e0f16822d578866e186a0974d65ad58cddc1e2ab";
      url =
        "https://git.pleroma.social/pleroma/elixir-libraries/elixir-captcha.git";
    };
    version = "e0f16822d578866e186a0974d65ad58cddc1e2ab";
  };
  trailing_format_plug = {
    builder = "mix";
    deps = [ "plug" ];
    fetchHex = {
      sha256 =
        "64b877f912cf7273bed03379936df39894149e35137ac9509117e59866e10e45";
      url = "https://repo.hex.pm/tarballs/trailing_format_plug-0.0.7.tar";
    };
    version = "0.0.7";
  };
  tesla = {
    builder = "mix";
    fetchGit = {
      rev = "af3707078b10793f6a534938e56b963aff82fe3c";
      url = "https://github.com/teamon/tesla.git";
    };
    version = "af3707078b10793f6a534938e56b963aff82fe3c";
  };
  eternal = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "d5b6b2499ba876c57be2581b5b999ee9bdf861c647401066d3eeed111d096bc4";
      url = "https://repo.hex.pm/tarballs/eternal-1.2.1.tar";
    };
    version = "1.2.1";
  };
  jose = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "16d8e460dae7203c6d1efa3f277e25b5af8b659febfc2f2eb4bacf87f128b80a";
      url = "https://repo.hex.pm/tarballs/jose-1.10.1.tar";
    };
    version = "1.10.1";
  };
  mimerl = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "67e2d3f571088d5cfd3e550c383094b47159f3eee8ffa08e64106cdf5e981be3";
      url = "https://repo.hex.pm/tarballs/mimerl-1.2.0.tar";
    };
    version = "1.2.0";
  };
  oban = {
    builder = "mix";
    deps = [ "ecto_sql" "jason" "postgrex" "telemetry" ];
    fetchHex = {
      sha256 =
        "e6ce70d94dd46815ec0882a1ffb7356df9a9d5b8a40a64ce5c2536617a447379";
      url = "https://repo.hex.pm/tarballs/oban-2.0.0.tar";
    };
    version = "2.0.0";
  };
  ecto_sql = {
    builder = "mix";
    deps = [ "db_connection" "ecto" "postgrex" "telemetry" ];
    fetchHex = {
      sha256 =
        "30161f81b167d561a9a2df4329c10ae05ff36eca7ccc84628f2c8b9fa1e43323";
      url = "https://repo.hex.pm/tarballs/ecto_sql-3.4.5.tar";
    };
    version = "3.4.5";
  };
  ex_aws_s3 = {
    builder = "mix";
    deps = [ "ex_aws" "sweet_xml" ];
    fetchHex = {
      sha256 =
        "c0258bbdfea55de4f98f0b2f0ca61fe402cc696f573815134beb1866e778f47b";
      url = "https://repo.hex.pm/tarballs/ex_aws_s3-2.0.2.tar";
    };
    version = "2.0.2";
  };
  linkify = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "2518bbbea21d2caa9d372424e1ad845b640c6630e2d016f1bd1f518f9ebcca28";
      url = "https://repo.hex.pm/tarballs/linkify-0.2.0.tar";
    };
    version = "0.2.0";
  };
  crypt = {
    builder = "mix";
    fetchGit = {
      rev = "f63a705f92c26955977ee62a313012e309a4d77a";
      url = "https://github.com/msantos/crypt.git";
    };
    version = "f63a705f92c26955977ee62a313012e309a4d77a";
  };
  accept = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "b33b127abca7cc948bbe6caa4c263369abf1347cfa9d8e699c6d214660f10cd1";
      url = "https://repo.hex.pm/tarballs/accept-0.3.5.tar";
    };
    version = "0.3.5";
  };
  benchee = {
    builder = "mix";
    deps = [ "deep_merge" ];
    fetchHex = {
      sha256 =
        "66b211f9bfd84bd97e6d1beaddf8fc2312aaabe192f776e8931cb0c16f53a521";
      url = "https://repo.hex.pm/tarballs/benchee-1.0.1.tar";
    };
    version = "1.0.1";
  };
  remote_ip = {
    builder = "mix";
    fetchGit = {
      rev = "b647d0deecaa3acb140854fe4bda5b7e1dc6d1c8";
      url = "https://git.pleroma.social/pleroma/remote_ip.git";
    };
    version = "b647d0deecaa3acb140854fe4bda5b7e1dc6d1c8";
  };
  meck = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "ffedb39f99b0b99703b8601c6f17c7f76313ee12de6b646e671e3188401f7866";
      url = "https://repo.hex.pm/tarballs/meck-0.8.13.tar";
    };
    version = "0.8.13";
  };
  jumper = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "3c00542ef1a83532b72269fab9f0f0c82bf23a35e27d278bfd9ed0865cecabff";
      url = "https://repo.hex.pm/tarballs/jumper-1.0.1.tar";
    };
    version = "1.0.1";
  };
  prometheus_plugs = {
    builder = "mix";
    deps = [ "accept" "plug" "prometheus_ex" ];
    fetchHex = {
      sha256 =
        "25933d48f8af3a5941dd7b621c889749894d8a1082a6ff7c67cc99dec26377c5";
      url = "https://repo.hex.pm/tarballs/prometheus_plugs-1.1.5.tar";
    };
    version = "1.1.5";
  };
  quack = {
    builder = "mix";
    deps = [ "poison" "tesla" ];
    fetchHex = {
      sha256 =
        "cca7b4da1a233757fdb44b3334fce80c94785b3ad5a602053b7a002b5a8967bf";
      url = "https://repo.hex.pm/tarballs/quack-0.1.1.tar";
    };
    version = "0.1.1";
  };
  gen_smtp = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "9f51960c17769b26833b50df0b96123605a8024738b62db747fece14eb2fbfcc";
      url = "https://repo.hex.pm/tarballs/gen_smtp-0.15.0.tar";
    };
    version = "0.15.0";
  };
  floki = {
    builder = "mix";
    deps = [ "html_entities" ];
    fetchHex = {
      sha256 =
        "6b29a14283f1e2e8fad824bc930eaa9477c462022075df6bea8f0ad811c13599";
      url = "https://repo.hex.pm/tarballs/floki-0.27.0.tar";
    };
    version = "0.27.0";
  };
  earmark_parser = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "6603d7a603b9c18d3d20db69921527f82ef09990885ed7525003c7fe7dc86c56";
      url = "https://repo.hex.pm/tarballs/earmark_parser-1.4.10.tar";
    };
    version = "1.4.10";
  };
  mogrify = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "9b2496dde44b1ce12676f85d7dc531900939e6367bc537c7243a1b089435b32d";
      url = "https://repo.hex.pm/tarballs/mogrify-0.7.4.tar";
    };
    version = "0.7.4";
  };
  fast_html = {
    builder = "mix";
    deps = [ "elixir_make" "nimble_pool" ];
    fetchHex = {
      sha256 =
        "4910ee49f2f6b19692e3bf30bf97f1b6b7dac489cd6b0f34cd0fe3042c56ba30";
      url = "https://repo.hex.pm/tarballs/fast_html-2.0.4.tar";
    };
    version = "2.0.4";
  };
  makeup = {
    builder = "mix";
    deps = [ "nimble_parsec" ];
    fetchHex = {
      sha256 =
        "e339e2f766d12e7260e6672dd4047405963c5ec99661abdc432e6ec67d29ef95";
      url = "https://repo.hex.pm/tarballs/makeup-1.0.3.tar";
    };
    version = "1.0.3";
  };
  credo = {
    builder = "mix";
    deps = [ "bunt" "jason" ];
    fetchHex = {
      sha256 =
        "92339d4cbadd1e88b5ee43d427b639b68a11071b6f73854e33638e30a0ea11f5";
      url = "https://repo.hex.pm/tarballs/credo-1.4.0.tar";
    };
    version = "1.4.0";
  };
  nimble_parsec = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "32111b3bf39137144abd7ba1cce0914533b2d16ef35e8abc5ec8be6122944263";
      url = "https://repo.hex.pm/tarballs/nimble_parsec-0.6.0.tar";
    };
    version = "0.6.0";
  };
  ecto = {
    builder = "mix";
    deps = [ "decimal" "jason" "telemetry" ];
    fetchHex = {
      sha256 =
        "2bcd262f57b2c888b0bd7f7a28c8a48aa11dc1a2c6a858e45dd8f8426d504265";
      url = "https://repo.hex.pm/tarballs/ecto-3.4.5.tar";
    };
    version = "3.4.5";
  };
  ex2ms = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "19e27f9212be9a96093fed8cdfbef0a2b56c21237196d26760f11dfcfae58e97";
      url = "https://repo.hex.pm/tarballs/ex2ms-1.5.0.tar";
    };
    version = "1.5.0";
  };
  http_signatures = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "4e4b501a936dbf4cb5222597038a89ea10781776770d2e185849fa829686b34c";
      url = "https://repo.hex.pm/tarballs/http_signatures-0.1.0.tar";
    };
    version = "0.1.0";
  };
  html_entities = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "1c9715058b42c35a2ab65edc5b36d0ea66dd083767bef6e3edb57870ef556549";
      url = "https://repo.hex.pm/tarballs/html_entities-0.5.1.tar";
    };
    version = "0.5.1";
  };
  mochiweb = {
    builder = "rebar3";
    fetchHex = {
      sha256 =
        "eb55f1db3e6e960fac4e6db4e2db9ec3602cc9f30b86cd1481d56545c3145d2e";
      url = "https://repo.hex.pm/tarballs/mochiweb-2.18.0.tar";
    };
    version = "2.18.0";
  };
  makeup_elixir = {
    builder = "mix";
    deps = [ "makeup" ];
    fetchHex = {
      sha256 =
        "4f0e96847c63c17841d42c08107405a005a2680eb9c7ccadfd757bd31dabccfb";
      url = "https://repo.hex.pm/tarballs/makeup_elixir-0.14.1.tar";
    };
    version = "0.14.1";
  };
  ueberauth = {
    builder = "mix";
    deps = [ "plug" ];
    fetchHex = {
      sha256 =
        "d42ace28b870e8072cf30e32e385579c57b9cc96ec74fa1f30f30da9c14f3cc0";
      url = "https://repo.hex.pm/tarballs/ueberauth-0.6.3.tar";
    };
    version = "0.6.3";
  };
  idna = {
    builder = "rebar3";
    deps = [ "unicode_util_compat" ];
    fetchHex = {
      sha256 =
        "689c46cbcdf3524c44d5f3dde8001f364cd7608a99556d8fbd8239a5798d4c10";
      url = "https://repo.hex.pm/tarballs/idna-6.0.0.tar";
    };
    version = "6.0.0";
  };
  httpoison = {
    builder = "mix";
    deps = [ "hackney" ];
    fetchHex = {
      sha256 =
        "ace7c8d3a361cebccbed19c283c349b3d26991eff73a1eaaa8abae2e3c8089b6";
      url = "https://repo.hex.pm/tarballs/httpoison-1.6.2.tar";
    };
    version = "1.6.2";
  };
  ex_const = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "d06e540c9d834865b012a17407761455efa71d0ce91e5831e86881b9c9d82448";
      url = "https://repo.hex.pm/tarballs/ex_const-0.2.4.tar";
    };
    version = "0.2.4";
  };
  concurrent_limiter = {
    builder = "mix";
    fetchGit = {
      rev = "55e92f84b4ed531bd487952a71040a9c69dc2807";
      url =
        "https://git.pleroma.social/pleroma/elixir-libraries/concurrent_limiter.git";
    };
    version = "55e92f84b4ed531bd487952a71040a9c69dc2807";
  };
  recon = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "430ffa60685ac1efdfb1fe4c97b8767c92d0d92e6e7c3e8621559ba77598678a";
      url = "https://repo.hex.pm/tarballs/recon-2.5.1.tar";
    };
    version = "2.5.1";
  };
  swoosh = {
    builder = "mix";
    deps = [ "cowboy" "gen_smtp" "hackney" "jason" "mime" "plug_cowboy" ];
    fetchHex = {
      sha256 =
        "c547cfc83f30e12d5d1fdcb623d7de2c2e29a5becfc68bf8f42ba4d23d2c2756";
      url = "https://repo.hex.pm/tarballs/swoosh-1.0.0.tar";
    };
    version = "1.0.0";
  };
  comeonin = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "7fe612b739c78c9c1a75186ef2d322ce4d25032d119823269d0aa1e2f1e20025";
      url = "https://repo.hex.pm/tarballs/comeonin-5.3.1.tar";
    };
    version = "5.3.1";
  };
  db_connection = {
    builder = "mix";
    deps = [ "connection" ];
    fetchHex = {
      sha256 =
        "3bbca41b199e1598245b716248964926303b5d4609ff065125ce98bcd368939e";
      url = "https://repo.hex.pm/tarballs/db_connection-2.2.2.tar";
    };
    version = "2.2.2";
  };
  inet_cidr = {
    builder = "mix";
    fetchHex = {
      sha256 =
        "a05744ab7c221ca8e395c926c3919a821eb512e8f36547c062f62c4ca0cf3d6e";
      url = "https://repo.hex.pm/tarballs/inet_cidr-1.0.4.tar";
    };
    version = "1.0.4";
  };
}

