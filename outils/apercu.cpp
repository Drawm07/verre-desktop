// Aperçu hors Windhawk : dessine chaque widget du mod dans une image BMP,
// sans rien afficher à l'écran. Sert à vérifier le rendu avant de charger le
// mod dans Windhawk. Les fonctions de Windhawk sont remplacées par des
// versions simples (réglages par défaut, journal muet).
//
// Variables d'environnement facultatives :
//   VERRE_APPS    dossier des raccourcis de la grille
//   VERRE_PRENOM  prénom de la salutation
//
// Usage : outils/apercu.sh

#include <windows.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#define WH_MOD_ID L"verre-desktop"
#define Wh_Log(...) ((void)0)

// Valeurs par défaut des réglages (les mêmes que dans le mod).
struct Reglage {
    const wchar_t* nom;
    const wchar_t* valeur;
};
const Reglage REGLAGES[] = {
    {L"dossier1Nom", L"Bureau"},          {L"dossier1Chemin", L"shell:Desktop"},
    {L"dossier2Nom", L"Documents"},       {L"dossier2Chemin", L"shell:Personal"},
    {L"dossier3Nom", L"Téléchargements"}, {L"dossier3Chemin", L"shell:Downloads"},
    {L"dossier4Nom", L"ESIEE"},           {L"dossier4Chemin", L""},
    {L"dossier5Nom", L"Projets"},         {L"dossier5Chemin", L""},
    {L"dossier6Nom", L"Images"},          {L"dossier6Chemin", L"shell:My Pictures"},
    {L"renommages", L"Samsung Notes=Notes; ChatGPT Classic=ChatGPT; "
                    L"Windows PowerShell=PowerShell"},
    {L"moteurRecherche", L"https://www.google.com/search?q=%s"},
    {L"couleurAccent", L"#66BCFF"},
    {L"fond", L"aucun"},       {L"dossierFonds", L"%USERPROFILE%\\Pictures\\Verre"},
    {L"diaporamaMinutes", L"0"},
    {L"opaciteVerre", L"37"},
    {L"horloge.x", L"28"},     {L"horloge.y", L"40"},
    {L"systeme.x", L"24"},     {L"systeme.y", L"250"},
    {L"accesRapide.marge", L"24"}, {L"accesRapide.y", L"64"},
    {L"recherche.y", L"64"},   {L"accueil.y", L"100"},
    {L"sites.x", L"24"},       {L"sites.y", L"680"},
    {L"pilotage.y", L"250"},
    {L"minutesConcentration", L"25"}, {L"minutesPause", L"5"},
    {L"site1Nom", L"YouTube"},      {L"site1Adresse", L"https://www.youtube.com"},
    {L"site2Nom", L"Gmail"},        {L"site2Adresse", L"https://mail.google.com"},
    {L"site3Nom", L"GitHub"},       {L"site3Adresse", L"https://github.com"},
    {L"site4Nom", L"ChatGPT"},      {L"site4Adresse", L"https://chatgpt.com"},
    {L"site5Nom", L"Wikipédia"},    {L"site5Adresse", L"https://fr.wikipedia.org"},
    {L"site6Nom", L"Google Drive"}, {L"site6Adresse", L"https://drive.google.com"},
};

PCWSTR Wh_GetStringSetting(PCWSTR nom, ...) {
    wchar_t complet[128];
    va_list arguments;
    va_start(arguments, nom);
    vswprintf(complet, 128, nom, arguments);
    va_end(arguments);
    // N'importe quel réglage peut être remplacé par une variable
    // d'environnement VERRE_<nom> (le point devient « _ »), par exemple
    // VERRE_couleurAccent=#FF8A65 ou VERRE_opaciteVerre=60.
    wchar_t variable[160] = L"VERRE_";
    wcscat(variable, complet);
    for (wchar_t* c = variable; *c; c++) {
        if (*c == L'.') *c = L'_';
    }
    if (_wgetenv(variable)) {
        return _wcsdup(_wgetenv(variable));
    }
    if (wcscmp(complet, L"dossierApps") == 0 && _wgetenv(L"VERRE_APPS")) {
        return _wcsdup(_wgetenv(L"VERRE_APPS"));
    }
    if (wcscmp(complet, L"prenom") == 0 && _wgetenv(L"VERRE_PRENOM")) {
        return _wcsdup(_wgetenv(L"VERRE_PRENOM"));
    }
    for (const Reglage& reglage : REGLAGES) {
        if (wcscmp(reglage.nom, complet) == 0) {
            return _wcsdup(reglage.valeur);
        }
    }
    return _wcsdup(L"");
}

void Wh_FreeStringSetting(PCWSTR texte) {
    free((void*)texte);
}

// Stockage du mod : un dossier temporaire (VERRE_STOCKAGE pour en choisir un).
size_t Wh_GetModStoragePath(PWSTR chemin, size_t taille) {
    const wchar_t* choisi = _wgetenv(L"VERRE_STOCKAGE");
    if (choisi) {
        lstrcpyn(chemin, choisi, (int)taille);
    } else {
        GetTempPath((DWORD)taille, chemin);
        wcscat(chemin, L"verre-desktop-stockage");
    }
    CreateDirectory(chemin, nullptr);
    return wcslen(chemin);
}

int Wh_GetIntValue(PCWSTR, int defaut) {
    return defaut;
}

BOOL Wh_SetIntValue(PCWSTR, int) {
    return TRUE;
}

size_t Wh_GetStringValue(PCWSTR, PWSTR texte, size_t) {
    texte[0] = L'\0';
    return 0;
}

BOOL Wh_SetStringValue(PCWSTR, PCWSTR) {
    return TRUE;
}

int Wh_GetIntSetting(PCWSTR nom, ...) {
    PCWSTR texte = Wh_GetStringSetting(nom);
    int valeur = _wtoi(texte);
    Wh_FreeStringSetting(texte);
    return valeur;
}

BOOL Wh_SetFunctionHook(void*, void*, void**) {
    return TRUE;
}

#include "../verre-desktop.wh.cpp"

// Écrit une image 32 bits (bleu, vert, rouge, alpha prémultiplié) en BMP.
bool EcrireBmp(const wchar_t* chemin, const void* pixels, int largeur,
               int hauteur) {
    BITMAPINFOHEADER infos = {};
    infos.biSize = sizeof(infos);
    infos.biWidth = largeur;
    infos.biHeight = -hauteur;
    infos.biPlanes = 1;
    infos.biBitCount = 32;
    infos.biCompression = BI_RGB;
    DWORD tailleImage = largeur * hauteur * 4;
    BITMAPFILEHEADER entete = {};
    entete.bfType = 0x4D42;  // « BM »
    entete.bfOffBits = sizeof(entete) + sizeof(infos);
    entete.bfSize = entete.bfOffBits + tailleImage;

    FILE* fichier = _wfopen(chemin, L"wb");
    if (!fichier) {
        return false;
    }
    fwrite(&entete, sizeof(entete), 1, fichier);
    fwrite(&infos, sizeof(infos), 1, fichier);
    fwrite(pixels, tailleImage, 1, fichier);
    fclose(fichier);
    return true;
}

int wmain(int argc, wchar_t** argv) {
    if (argc < 2) {
        fwprintf(stderr, L"usage : apercu.exe <dossier de sortie>\n");
        return 1;
    }
    SetThreadDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);
    CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);
    g_module = GetModuleHandle(nullptr);

    if (FAILED(D2D1CreateFactory(D2D1_FACTORY_TYPE_SINGLE_THREADED,
                                 __uuidof(ID2D1Factory), nullptr,
                                 (void**)&g_fabriqueD2D)) ||
        FAILED(DWriteCreateFactory(DWRITE_FACTORY_TYPE_SHARED,
                                   __uuidof(IDWriteFactory),
                                   (IUnknown**)&g_fabriqueTexte))) {
        return 1;
    }
    D2D1_STROKE_STYLE_PROPERTIES rond = D2D1::StrokeStyleProperties(
        D2D1_CAP_STYLE_ROUND, D2D1_CAP_STYLE_ROUND, D2D1_CAP_STYLE_ROUND,
        D2D1_LINE_JOIN_ROUND);
    g_fabriqueD2D->CreateStrokeStyle(&rond, nullptr, 0, &g_traitRond);
    const FLOAT POINTILLES[] = {4.0f, 3.0f};
    D2D1_STROKE_STYLE_PROPERTIES pointille = D2D1::StrokeStyleProperties(
        D2D1_CAP_STYLE_FLAT, D2D1_CAP_STYLE_FLAT, D2D1_CAP_STYLE_FLAT,
        D2D1_LINE_JOIN_ROUND, 10.0f, D2D1_DASH_STYLE_CUSTOM);
    g_fabriqueD2D->CreateStrokeStyle(&pointille, POINTILLES, 2,
                                     &g_traitPointille);

    WNDCLASSEX classe = {};
    classe.cbSize = sizeof(classe);
    classe.lpfnWndProc = DefWindowProc;
    classe.hInstance = g_module;
    classe.lpszClassName = L"VerreDesktop_Apercu";
    RegisterClassEx(&classe);

    // Quelques prises de mesures à une seconde d'écart, comme dans le mod.
    LireReglages();
    DemarrerMesures();
    for (int i = 0; i < 3; i++) {
        MettreAJourMesures();
        Sleep(1000);
    }
    MettreAJourMesures();

    // Lecture des apps, directement (le mod le fait dans un thread à part).
    DemandeApps demande = {};
    demande.tailleIcone = 52;
    lstrcpyn(demande.dossier, g_dossierApps, MAX_PATH);
    lstrcpyn(demande.renommages, g_renommages, ARRAYSIZE(demande.renommages));
    g_apps = LireApps(&demande);
    wprintf(L"apps : %d dans %ls\n", g_apps ? g_apps->nombre : 0,
            g_dossierApps);
    for (int i = 0; g_apps && i < g_apps->nombre; i++) {
        wprintf(L"  %2d %-16ls icone %dx%d\n", i + 1, g_apps->apps[i].nom,
                g_apps->apps[i].largeurIcone, g_apps->apps[i].hauteurIcone);
    }

    // Catalogue de la recherche : lu directement, puis reçu par le
    // contrôleur comme dans le mod.
    g_controleur = CreateWindowEx(0, L"VerreDesktop_Apercu", L"", 0, 0, 0, 0, 0,
                                  HWND_MESSAGE, nullptr, g_module, nullptr);
    SetWindowLongPtr(g_controleur, GWLP_WNDPROC, (LONG_PTR)ProcedureWidget);
    FilLectureCatalogue(nullptr);
    MSG msg;
    while (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE)) {
        DispatchMessage(&msg);
    }
    wprintf(L"catalogue : %d apps\n", g_catalogue ? g_catalogue->nombre : 0);

    // Montre l'état « survolé » sur un bouton de chaque carte cliquable, et
    // la barre de recherche ouverte avec « spo » tapé.
    // Index des dossiers et aperçus des sites, directement (le mod le fait
    // dans des threads à part). Les aperçus manquants sont photographiés par
    // Chrome : quelques secondes par site la première fois.
    DemandeIndex* index = (DemandeIndex*)HeapAlloc(GetProcessHeap(),
                                                   HEAP_ZERO_MEMORY,
                                                   sizeof(DemandeIndex));
    for (int i = 0; i < 6; i++) {
        lstrcpyn(index->racines[i], g_dossiers[i].chemin, MAX_PATH);
    }
    FilIndexDossiers(index);
    DemandeApercus* apercus = (DemandeApercus*)HeapAlloc(
        GetProcessHeap(), HEAP_ZERO_MEMORY, sizeof(DemandeApercus));
    WCHAR stockage[MAX_PATH];
    Wh_GetModStoragePath(stockage, MAX_PATH);
    Joindre(apercus->dossier, MAX_PATH, stockage, L"apercus");
    SHCreateDirectoryEx(nullptr, apercus->dossier, nullptr);
    apercus->generation = g_generationApercus;
    for (int i = 0; i < NB_FAVORIS; i++) {
        lstrcpyn(apercus->adresses[i], g_favoris[i].adresse, 1024);
    }
    FilApercus(apercus);
    while (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE)) {
        DispatchMessage(&msg);
    }
    wprintf(L"index : %d dossiers\n", g_index ? g_index->nombre : 0);
    for (int i = 0; i < NB_FAVORIS; i++) {
        if (g_favoris[i].adresse[0]) {
            wprintf(L"apercu %ls : %ls\n", g_favoris[i].nom,
                    g_favoris[i].pixels ? L"oui" : L"non");
        }
    }

    // Poste de pilotage : minuteur en cours et temps d'écran d'EXEMPLE (les
    // vrais chiffres demandent des heures d'usage).
    g_sessionsDuJour = 2;
    RemettreMinuteur();
    g_resteMs = 14 * 60000 + 32000;
    struct { const wchar_t* nom; int minutes; } exemples[] = {
        {L"Google Chrome", 130}, {L"Microsoft Word", 65},
        {L"Autodesk Fusion", 52}, {L"Spotify", 25}, {L"Explorateur", 12}};
    for (auto& exemple : exemples) {
        TempsApp& app = g_tempsEcran[g_nbAppsSuivies++];
        lstrcpy(app.nom, exemple.nom);
        app.secondes = exemple.minutes * 60;
    }

    // État « propre » pour les captures : rien de survolé, recherche fermée,
    // sites repliés. VERRE_DEMO=1 montre au contraire les états actifs.
    if (_wgetenv(L"VERRE_DEMO")) {
        g_accesRapide.survol = 1;
        g_accueil.survol = 0;
        g_sitesOuverts = true;
        g_sites.survol = 2;
        g_pilotage.survol = ZONE_MARCHE;
        g_etatMemoire = ENTRETIEN_FINI;
        g_octetsLiberesMemoire = 1288490188LL;
        g_etatDisque = ENTRETIEN_A_CONFIRMER;
        g_octetsAnalyses = 1932735283LL;
    }
    g_barreActive = false;

    // Même ordre que g_widgets dans le mod.
    const wchar_t* noms[] = {L"recherche",    L"horloge", L"systeme",
                             L"acces-rapide", L"sites",   L"pilotage",
                             L"accueil"};
    int numero = 0;
    for (Widget* widget : g_widgets) {
        // Fenêtre jamais affichée : elle sert seulement à connaître l'échelle.
        widget->fenetre = CreateWindowEx(0, L"VerreDesktop_Apercu", L"", WS_POPUP,
                                         0, 0, 1, 1, nullptr, nullptr,
                                         g_module, nullptr);
        float echelle = Echelle(widget->fenetre);
        int largeur = Arrondir(widget->largeur * echelle);
        int hauteur = Arrondir(widget->hauteur * echelle);

        BITMAPINFO infos = {};
        infos.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
        infos.bmiHeader.biWidth = largeur;
        infos.bmiHeader.biHeight = -hauteur;
        infos.bmiHeader.biPlanes = 1;
        infos.bmiHeader.biBitCount = 32;
        infos.bmiHeader.biCompression = BI_RGB;
        HDC memoire = CreateCompatibleDC(nullptr);
        void* pixels = nullptr;
        HBITMAP image = CreateDIBSection(memoire, &infos, DIB_RGB_COLORS,
                                         &pixels, nullptr, 0);
        SelectObject(memoire, image);

        if (DessinerDansImage(widget, memoire, largeur, hauteur)) {
            wchar_t chemin[MAX_PATH];
            swprintf(chemin, MAX_PATH, L"%ls\\%ls.bmp", argv[1], noms[numero]);
            EcrireBmp(chemin, pixels, largeur, hauteur);
            wprintf(L"%ls %dx%d echelle=%.3f\n", noms[numero], largeur,
                    hauteur, echelle);
        } else {
            wprintf(L"%ls : ECHEC du dessin\n", noms[numero]);
        }
        DeleteDC(memoire);
        DeleteObject(image);
        numero++;
    }

    wprintf(L"cpu=%.0f%% ram=%.1f/%.1f gpu=%.0f%% disque=%.0f/%.0f "
            L"descente=%.0f montee=%.0f\n",
            g_mesures.cpu * 100, g_mesures.ramUtiliseeGo,
            g_mesures.ramTotaleGo, g_mesures.gpu * 100,
            g_mesures.disqueUtiliseGo, g_mesures.disqueTotalGo,
            g_mesures.descenteOctetsParS, g_mesures.monteeOctetsParS);
    return 0;
}
