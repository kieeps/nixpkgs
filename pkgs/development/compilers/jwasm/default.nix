{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jwasm";
  version = "2.15";

  src = fetchFromGitHub {
    owner = "Baron-von-Riedesel";
    repo  = "JWasm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ef4uEtEpnqYGhFmxuefJ40zyOuHsiPOLpH/52i7a7KI=";
  };

  outputs = [ "out" "doc" ];

  dontConfigure = true;

  preBuild = ''
    cp ${if stdenv.cc.isClang then "CLUnix.mak" else "GccUnix.mak"} Makefile
    substituteInPlace Makefile \
      --replace "/usr/local/bin" "${placeholder "out"}/bin"
  '';

  postInstall = ''
    install -Dpm644 $src/Html/License.html \
                    $src/Html/Manual.html \
                    $src/Html/Readme.html \
                    -t $doc/share/doc/jwasm/
  '';

  meta = with lib; {
    homepage = "https://github.com/Baron-von-Riedesel/JWasm/";
    description = "A MASM-compatible x86 assembler";
    changelog = "https://github.com/Baron-von-Riedesel/JWasm/releases/tag/v${finalAttrs.version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
})
# TODO: generalize for Windows builds
