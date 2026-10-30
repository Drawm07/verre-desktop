# Fonds d'écran « Verre » : à intégrer au mod Windhawk

12 fonds d'écran faits pour l'interface Verre (dock FrostyGlass, widgets en verre, accent bleu ciel `#66BCFF`).
Tous en **3840 × 2160 (4K), PNG**. Ce dépôt contient les fonds 06 à 11 en JPG ; le 12 n'est pas publié (voir Licence).

## Décision de David
David lève l'interdiction : la **gestion des fonds d'écran** entre dans le cadre du mod. Mets d'abord à jour `docs/PRD.md` (section Cœur minimal), puis code.
Ce qui est attendu : choisir un fond depuis les réglages du mod (liste déroulante), et en option un diaporama avec intervalle. Rien de plus (pas de téléchargement en ligne, pas de fond animé).

## Set 1 : « Papier découpé » (01 à 05)
Bandes arrondies imbriquées, ombres douces, effet papier découpé. Générées en SVG (`sources/papier-decoupe.py`).

| Fichier | Nom | Ambiance |
|---|---|---|
| `01-graphite.png` | Graphite | gris anthracite, le plus sobre |
| `02-nuit-bleue.png` | Nuit bleue | anneaux concentriques bleus en bas à droite |
| `03-amethyste.png` | Améthyste | violet, bandes en diagonale |
| `04-lagon.png` | Lagon | sarcelle, trois arches |
| `05-aurore.png` | Aurore | bleu, violet, sarcelle (palette de l'interface) |

## Set 2 : « Lumière » (06 à 12), le set préféré de David
Fonds très sombres, lumière qui accroche les arêtes, dégradés bleu → violet → sarcelle, grand vide à gauche pour les widgets. Générés en shaders GLSL (`sources/*.glsl`, rendus par `sources/rendu.py` avec Playwright + WebGL), sauf le 12.

| Fichier | Nom | Description |
|---|---|---|
| `06-eclipse.png` | Éclipse | bord de planète éclairé par derrière, trait violet → bleu |
| `07-orbite.png` | Orbite | sphère + 3 anneaux en 3D, reflets irisés |
| `08-soie.png` | Soie | tissu sombre aux reflets bleutés (**fond actif de David**) |
| `09-dunes.png` | Dunes | collines de nuit sous une lune |
| `10-capsules-lumiere.png` | Capsules de lumière | contours de capsules arrondies lumineux |
| `11-aurore-boreale.png` | Aurore boréale | rideaux sarcelle, bleu, violet |
| `12-gemini-anneaux.png` | Anneaux | image faite par David avec Gemini, agrandie de 2576 × 1438 vers la 4K (un peu moins nette) |

## Notes pour l'intégration
- Couleurs communes : fond `#0E0F13` à `#16171D`, bleu `#5CB3FF`, violet `#8061FF`, sarcelle `#38B8B0`. Pas d'orange, pas de noir ni de blanc purs.
- Les widgets sont placés sur la gauche et la droite : les sujets des fonds 06 à 11 laissent la gauche libre.
- Changer le fond : API documentée `IDesktopWallpaper` (ou `SystemParametersInfo(SPI_SETDESKWALLPAPER)`), à vérifier. Appliquer le même fond à tous les bureaux virtuels.
- Les sources permettent de régénérer un fond à une autre résolution (ex. 5K) en changeant `W` et `H` dans `rendu.py`.
- Le dossier des fonds est un réglage du mod, pas un chemin en dur (dépôt public).
- Licence : fonds 01 à 11 créés pour ce projet. Le 12 vient de Gemini : vérifier les conditions d'utilisation de Google avant de le publier sur GitHub, sinon le laisser hors du dépôt public.
