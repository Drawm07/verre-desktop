# PRD : Verre Desktop (mod Windhawk)

Statut : brouillon à valider par David. Date : 29/10/2026.

## Problème
L'interface de bureau faite avec Rainmeter (widgets du bureau 1, écran d'accueil du bureau 2) est jolie mais pas fiable : démarrage jusqu'à 5 minutes après l'ouverture de session, disparition après une mise en veille, pas de vrai flou, et un léger clignotement au changement de bureau.

## Utilisateurs
- David, sur son PC (Windows 11, 1920 × 1080, échelle 150 %).
- Visiteurs du portfolio GitHub, qui lisent le code et peuvent installer le mod.

## Cœur minimal (version 1)
1. **Widgets du bureau 1** : grande horloge + date en français, carte Système (CPU + courbe, mémoire, GPU, disque C:, réseau), carte Accès rapide (6 dossiers + explorateur).
2. **Écran d'accueil du bureau 2** : salutation selon l'heure, pastilles CPU/RAM/Disque, grille d'apps lue depuis un dossier de raccourcis (vraies icônes, sans flèche), tuile Ajouter, barre Dossiers.
3. **Chaque groupe attaché à son bureau virtuel** : il glisse avec son bureau au geste 4 doigts, sans clignotement.
4. **Vrai flou de verre** derrière les cartes, avec retombée sur un verre teinté.
5. **Réglages** dans le panneau Windhawk : dossier des apps, chemins des dossiers, positions, opacité, accent.
6. **Barre de recherche** en haut du bureau 1 (ajoutée par David le 30/10/2026) : la saisie propose les apps (dossier Applications de Windows), les dossiers rangés dans les dossiers de l'Accès rapide (ordre alphabétique), puis « rechercher sur le web » (ouvert dans Chrome) et « chercher dans les fichiers » (recherche de l'Explorateur). Entrée lance la ligne choisie.
7. **Bouton Sites** sous la carte Système (30/10/2026) : un clic déroule des aperçus de sites (petits écrans + nom) qu'on fait défiler ; un clic ouvre le site dans Chrome. Les aperçus sont photographiés une seule fois par site par Chrome invisible, avec un profil dédié. Chaque site a un compte Chrome réglable (adresse du compte → son profil Chrome ; « choisir » → choix du profil au clic ; vide → profil habituel), ajouté le 31/10/2026.
8. **Poste de pilotage** au centre du bureau 1 (30/10/2026) : minuteur de concentration en anneau fin lumineux (travail / pause, cycle de 4 sessions, sessions du jour) et temps d'écran du jour par app (top 4, sans les pauses de plus de 5 min). Volume, luminosité et batterie retirés : David les règle déjà avec ses touches.
9. **Fonds d'écran** (31/10/2026, décision de David) : choix d'un des 7 fonds « Lumière » dans une liste des réglages (défaut : ne pas changer le fond), dossier des fonds réglable, diaporama optionnel avec intervalle. Fond fixe : posé à la première visite de chaque bureau. Diaporama : seul le bureau affiché change, chaque bureau garde le sien (Windows ne permet pas de préparer le fond d'un autre bureau : mesuré le 31/10/2026). Rien de plus : pas de téléchargement, pas de fond animé.
10. **Entretien** (31/10/2026) sur la carte Système : bouton « Libérer » (vide la mémoire de travail des apps, sauf celle au premier plan ; aucune app fermée) et bouton « Nettoyer » (analyse puis confirmation : fichiers temporaires de plus d'un jour, rapports de plantage, corbeille).

## Critères de réussite
- Les widgets sont visibles moins de 10 s après l'apparition du bureau, et après chaque réveil de veille.
- 20 changements de bureau d'affilée sans aucun widget visible au mauvais endroit.
- Texte et coins nets à 150 %.
- Désactiver le mod enlève tout, sans redémarrer l'Explorateur ; aucun plantage de l'Explorateur sur une semaine d'usage.

## Niveau d'ambition
**Niveau 2 : outil perso local.** Un seul fichier `.wh.cpp`, chargé comme « mod outil » dans son propre processus `windhawk.exe` (pas dans l'Explorateur). Aucun serveur, aucun compte, aucune base de données, aucune dépendance payante. Coût mensuel : 0 €.

## Outils
| Outil | Rôle | Coût |
|---|---|---|
| Windhawk | charge et compile le mod | gratuit |
| Win32, Direct2D, DirectWrite, DWM, Shell | dessin, flou, icônes, bureaux virtuels | inclus dans Windows |
| GitHub | dépôt public (portfolio) | gratuit |

## Hors-cadre (interdit en version 1)
- Remplacer ou modifier le dock, l'horloge de la barre, le menu Démarrer, la recherche : Windhawk les gère déjà avec d'autres mods.
- Groupe « Navigateurs » dans le dock (abandonné par David).
- Météo, actualités, calendrier, musique en cours, notifications, ou tout widget non listé ci-dessus.
- Animations décoratives (rebonds, parallaxe, fond animé) au-delà d'un léger survol des boutons.
- Glisser-déposer pour réorganiser les tuiles (l'ordre vient du préfixe numérique des fichiers).
- Thème clair, multi-écran avancé, support de Windows 10.
- Publication dans le dépôt officiel `windhawk-mods`.
- Toute connexion réseau, télémétrie ou mise à jour automatique. Deux exceptions décidées par David le 30/10/2026 : ouvrir le navigateur (recherche web, sites), et faire photographier un site par Chrome invisible une seule fois pour son aperçu. Le mod lui-même n'a aucun code réseau.
- Raccourci clavier global pour ouvrir la barre de recherche (Backlog si besoin).

## Backlog (idées gardées au frais)
- Petits points en haut de l'écran indiquant le bureau actuel : repère utile, mais pas indispensable au cœur.
- Thème clair crème : cohérent avec les goûts de David, mais double le travail de test.
- Publication dans `windhawk-mods` : à envisager une fois le mod stable plusieurs semaines.
- Réordonner les tuiles à la souris.
- V2 : fonds d'écran animés (David les fabriquera).

## Portfolio GitHub (dépôt public à terme)
- Licence proposée : **MIT** (à confirmer par David).
- Aucun chemin personnel ni nom d'utilisateur en dur : tout passe par les réglages, avec des valeurs par défaut génériques (`shell:Desktop`…).
- `.gitignore` écrit avant le premier commit ; historique vérifié avant de rendre le dépôt public.
- README avec captures, installation pas à pas, et la liste honnête de ce qui a été testé.
- Crédit clair : code écrit avec l'aide de Claude Code, sous la direction de David.
- Fonds : les 01 à 11 ont été créés pour ce projet. Le 12 (Gemini) reste hors du dépôt public tant que les conditions de Google ne sont pas vérifiées.
