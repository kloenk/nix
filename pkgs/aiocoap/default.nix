{ lib
, buildPythonPackage
, fetchPypi
, cython
}:

buildPythonPackage rec{
  pname = "aiocoap";
  version = "0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "402d4151db6d8d0b1d66af5b6e10e0de1521decbf12140637e5b8d2aa9c5aef6";
  };

  checkInputs = [ cython ];


  doCheck = false;


  meta = with lib; {
    #homepage = https://github.com/pytoolz/toolz;
    description = "aiocoap module";
    #license = licenses.mit;
  };
}