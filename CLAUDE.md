# Verre Desktop : consignes pour Claude Code

Lis d'abord `BRIEF-Claude-Code.md` (contexte, design, pistes techniques, règles de sécurité) puis `docs/PRD.md`.

## Périmètre
Ne développe aucune fonctionnalité absente de `docs/PRD.md`. Si une nouvelle idée apparaît, ajoute-la à la section Backlog du PRD, explique pourquoi elle attend, et ne la code que lorsque David lève explicitement l'interdiction.

## Niveau d'ambition
Niveau 2, outil perso local : un seul fichier `.wh.cpp`, API Windows uniquement. Pas de serveur, pas de compte, pas de dépendance externe, pas de connexion réseau. Coût : 0 €.

## Façon de travailler
- Une brique à la fois, dans l'ordre du brief (section 7). Capture d'écran et validation de David avant la suivante.
- Explique chaque brique en français simple ; noms de fonctions et variables en français quand c'est possible.
- Vérifie toute API dans la documentation officielle (windhawk.net, Microsoft Learn, mods existants de `ramensoftware/windhawk-mods`). Si tu n'es pas sûr, dis-le.
- Le mod est un « mod outil » : il tourne dans son propre processus `windhawk.exe`, pas dans `explorer.exe` (décision du 29/10/2026). Applique quand même les règles de sécurité du brief (section 6) à chaque modification.
- Avant de charger le mod dans Windhawk, compile-le en local avec le Clang de Windhawk (`outils/compiler.sh`).
- Aucun chemin personnel en dur : tout passe par les réglages du mod (dépôt public à terme).
- Signale clairement ce qui est testé pour de vrai et ce qui ne l'est pas.
