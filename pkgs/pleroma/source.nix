{ fetchFromGitLab }:

rec {
  version = "2.1.2";
  src = fetchFromGitLab {
    domain = "git.pleroma.social";
    owner = "pleroma";
    repo = "pleroma";
    rev = "v2.1.2";
    sha256 = "1c015gyj0x8dm3lws15b362i3fn05whv15ipw0k42mzrzn5jwicn";
  };
}

