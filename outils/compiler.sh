#!/usr/bin/env bash
# Compile verre-desktop.wh.cpp avec le Clang fourni par Windhawk 1.7.3 et les
# mêmes options que lui, pour voir les erreurs AVANT de charger le mod.
# Ne charge rien dans Windhawk : produit seulement des DLL de test jetables.
#
# Usage (Git Bash) : outils/compiler.sh

set -euo pipefail

WINDHAWK="${WINDHAWK:-/c/Program Files/Windhawk}"
MOTEUR="$WINDHAWK/Engine/1.7.3"
RACINE="$(cd "$(dirname "$0")/.." && pwd)"
SOURCE="$RACINE/verre-desktop.wh.cpp"
SORTIE="${TMP:-/tmp}/verre-desktop-test"
mkdir -p "$SORTIE"

# Les options de liaison écrites dans le mod (ligne @compilerOptions).
read -r -a OPTIONS_MOD <<< "$(sed -n 's#^// @compilerOptions##p' "$SOURCE")"

# windhawk.exe est en 32 bits ; on teste aussi le 64 bits pour Windhawk 2.0.
for cible in i686-w64-mingw32:32 x86_64-w64-mingw32:64; do
    triplet="${cible%%:*}"
    bits="${cible##*:}"
    echo "== Compilation $bits bits"
    "$WINDHAWK/Compiler/bin/clang++.exe" \
        -std=c++23 -O2 -shared -DUNICODE -D_UNICODE \
        -DWINVER=0x0A00 -D_WIN32_WINNT=0x0A00 -D_WIN32_IE=0x0A00 \
        -DNTDDI_VERSION=0x0A000008 -D__USE_MINGW_ANSI_STDIO=0 -DWH_MOD \
        '-DWH_MOD_ID=L"verre-desktop"' '-DWH_MOD_VERSION=L"test"' \
        -Wall -Wextra -Wno-unused-parameter -Wno-missing-field-initializers \
        -Wno-cast-function-type-mismatch \
        -include windhawk_api.h -x c++ "$SOURCE" -x none -target "$triplet" \
        -Wl,--export-all-symbols -o "$SORTIE/verre-desktop-$bits.dll" \
        "$MOTEUR/$bits/windhawk.lib" "${OPTIONS_MOD[@]}"
    echo "   OK : $SORTIE/verre-desktop-$bits.dll"
done
