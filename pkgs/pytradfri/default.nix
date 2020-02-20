{ lib
, buildPythonPackage
, fetchPypi
, aiocoap
, cython
}:

buildPythonPackage rec{
  pname = "pytradfri";
  version = "6.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e92254adc90e16d317988714a9f06669887e9a3f671c3d580c3c7e7535cb8c5";
  };

  checkInputs = [ aiocoap cython ];

  doCheck = false;
  
  meta = with lib; {
    #homepage = https://github.com/pytoolz/toolz;
    description = "pytradfri module";
    license = licenses.mit;
  };
}