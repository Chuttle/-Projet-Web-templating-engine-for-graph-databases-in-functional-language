HTMLBuilder peut être utilisé de plusieurs façons: de manière statique, dynamique via les outils pré-préparés, ou via vos propres outils.

1) Utiliser les éxécutable déjà présent
Pour générer les éxecutables, lancez 'cabal install' dans le dossier racine du projet.

Ensuite, dans un dossier contenant les trois fichier graph.dat, infos.dat et style.dat décrits plus bas, lancez 'Web-Templating-Static' ou 'Web-Templating-Dynamic'.

Web-Templating-Static génèrera tous les fichiers HTML dans le dossier. Si des fichiers portaient le même nom ils seront écrasés.
Web-Templating-Dynamic lancera un serveur sur le port 8000 de la machine (vous pouvez modifier le port avec le paramètre -p). Ce serveur pourra générer automatiquement les pages demandées.

Ces deux éxécutables sont aussi dispobibles dans les dossier dist/build/Web-Templating-Static et dist/build/Web-Templating-Dynamic respectivement.


2) Utiliser d'une autre manière les outils de l'HTMLBuilder

Pour réutiliser le code, il faut importer le module HTMLBuilder entièrement, puis utiliser la fonction creerPage.


3) Format à utiliser pour les données à entrer:

- graph.dat : chaque relation sera écrite sous la forme (premier élément, nom de la relation, deuxième élément), chaque élément étant entre guillemets et les relations séparées par des virgules et le tout est mis entre crochets.
Dans le futur, il pourra être envisagé d'automatiser la création de ce fichier.


- infos.dat : ce fichier sera de la même forme que graph.dat, si ce n'est que le premier élément doit être dans le premier graphe, le second est soit HTMLType (pour lier une page et un style, voir plus bas), soit Description (le dernier paramètre sera alors un texte, soit Image (le dernier paramètre sera alors le lien vers une image).
le deuxième élément n'est pas entre guillemets.
Dans le futur, il sera possible d'ajouter d'autres options pour le deuxième élément.

- style.dat : ce fichier décrit les pages HTML qui seront générées.
Chaque style est composé d'un nom (entre guillemets) et d'un noeud, qui contient l'ensemble de la page. Chaque style est entre parenthèses et ils sont séparés par des virgules, l'ensemble est entre crochets.
Plusieurs types de noeuds sont possibles:

Node nom [Parameter] [Style] -> représente une balise HTML. nom est le nom de la balise entre guillemets, [Parameter] est une liste d'attributs de la balise comme décrit plus bas, et Style est une liste des Noeuds qui seront dans la balise.
Text texte -> insère un texte de votre choix
Title  -> insère le titre de la page
IterateRelation [Style]  -> permet de reproduire une fois par relation la série de balise contenue
LinkName -> permet d'insérer le nom de la première relation active. Utilisable dans un noeud IterateRelation
LinkTarget -> permet d'insérer la cible de la première relation active. Utilisable dans un noeud IterateRelation 
IterateInfos Type [Style] -> permet de reproduire une fois par élément du fichier info du type précisé la série de balise contenue
Info -> permet d'insérer la cible de la première Info active. Utilisable dans un noeud IterateInfos


Les attributs peuvent être écrits de ces manières:
Param String String -> pour un attribut fixe, en premier le nom de l'attribut en second la valeur
Link String         -> la valeur de l'attribut est la cible de la première relation active à laquelle est ajouté un .html, afin de créer un lien. Utilisable dans un noeud IterateRelation
TitleP String       -> la valeur de l'attribut est le nom de la page
InfoP String        -> la valeur de l'attribut est la cible de la première Info active. Utilisable dans un noeud IterateInfos