#!/usr/bin/env bash
# Aperçu sans Windhawk : compile outils/apercu.cpp, dessine les widgets dans
# des images, puis les pose sur le fond d'écran de la maquette aux positions
# du mod (écran 1920 × 1080 à 150 %). Produit deux images : bureau 1 et
# écran d'accueil (autres bureaux).
# Compilé en 32 bits, comme windhawk.exe : certaines choses (icônes des apps
# du Store) ne se comportent pas pareil en 64 bits.
#
# Usage (Git Bash) :
#   VERRE_APPS='C:\...\Apps' VERRE_PRENOM=David outils/apercu.sh

set -euo pipefail

WINDHAWK="${WINDHAWK:-/c/Program Files/Windhawk}"
RACINE="$(cd "$(dirname "$0")/.." && pwd)"
SORTIE="${TMP:-/tmp}/verre-desktop-apercu"
mkdir -p "$SORTIE" "$RACINE/captures"

read -r -a OPTIONS_MOD <<< "$(sed -n 's#^// @compilerOptions##p' "$RACINE/verre-desktop.wh.cpp")"

"$WINDHAWK/Compiler/bin/clang++.exe" -std=c++23 -O2 -municode \
    -DUNICODE -D_UNICODE -DWINVER=0x0A00 -D_WIN32_WINNT=0x0A00 \
    -D_WIN32_IE=0x0A00 -DNTDDI_VERSION=0x0A000008 -D__USE_MINGW_ANSI_STDIO=0 \
    -target i686-w64-mingw32 -static "$RACINE/outils/apercu.cpp" \
    -o "$SORTIE/apercu.exe" "${OPTIONS_MOD[@]}"

"$SORTIE/apercu.exe" "$(cygpath -w "$SORTIE")"

python -I - "$SORTIE" "${VERRE_FOND:-$RACINE/docs/fond-maquette-4k-vif.png}" "$RACINE/captures" "${VERRE_NOM:-apercu}" <<'EOF'
import sys
import numpy as np
from PIL import Image

dossier, fond_chemin, sortie, prefixe = sys.argv[1:5]
fond = Image.open(fond_chemin).convert("RGB").resize((1920, 1080), Image.LANCZOS)

# Positions du mod, en pixels réels à 150 %.
bureaux = {
    f"{prefixe}-bureau1.png": {"horloge": (28, 40), "systeme": (24, 250),
                           "acces-rapide": (1920 - 24 - 450, 64),
                           "sites": (24, 680),
                           "pilotage": ((1920 - 720) // 2, 250),
                           # en dernier : sa liste passe par-dessus les cartes
                           "recherche": ((1920 - 640) // 2, 64)},
    f"{prefixe}-accueil.png": {"accueil": ((1920 - 1016) // 2, 100)},
}
for fichier, widgets in bureaux.items():
    ecran = np.asarray(fond).astype(np.float32) / 255.0
    for nom, (x, y) in widgets.items():
        with open(f"{dossier}/{nom}.bmp", "rb") as f:
            donnees = f.read()
        w = int.from_bytes(donnees[18:22], "little", signed=True)
        h = -int.from_bytes(donnees[22:26], "little", signed=True)
        # Bleu, vert, rouge et opacité, couleurs déjà prémultipliées.
        brut = np.frombuffer(donnees[54:54 + w * h * 4], dtype=np.uint8).reshape(h, w, 4) / 255.0
        couleur, alpha = brut[..., [2, 1, 0]], brut[..., 3:4]
        zone = ecran[y:y + h, x:x + w]
        ecran[y:y + h, x:x + w] = couleur + zone * (1 - alpha)
    Image.fromarray((np.clip(ecran, 0, 1) * 255).astype(np.uint8)).save(f"{sortie}/{fichier}")
    print("aperçu :", f"{sortie}/{fichier}")
EOF
