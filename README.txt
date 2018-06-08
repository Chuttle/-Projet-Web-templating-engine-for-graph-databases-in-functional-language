HTMLBuilder peut �tre utilis� de plusieurs fa�ons: de mani�re statique, dynamique via les outils pr�-pr�par�s, ou via vos propres outils.

1) Utiliser les �x�cutable d�j� pr�sent
Pour g�n�rer les �xecutables, lancez 'cabal install' dans le dossier racine du projet.

Ensuite, dans un dossier contenant les trois fichier graph.dat, infos.dat et style.dat d�crits plus bas, lancez 'Web-Templating-Static' ou 'Web-Templating-Dynamic'.

Web-Templating-Static g�n�rera tous les fichiers HTML dans le dossier. Si des fichiers portaient le m�me nom ils seront �cras�s.
Web-Templating-Dynamic lancera un serveur sur le port 8000 de la machine (vous pouvez modifier le port avec le param�tre -p). Ce serveur pourra g�n�rer automatiquement les pages demand�es.

Ces deux �x�cutables sont aussi dispobibles dans les dossier dist/build/Web-Templating-Static et dist/build/Web-Templating-Dynamic respectivement.


2) Utiliser d'une autre mani�re les outils de l'HTMLBuilder

Pour r�utiliser le code, il faut importer le module HTMLBuilder enti�rement, puis utiliser la fonction creerPage.


3) Format � utiliser pour les donn�es � entrer:

- graph.dat : chaque relation sera �crite sous la forme (premier �l�ment, nom de la relation, deuxi�me �l�ment), chaque �l�ment �tant entre guillemets et les relations s�par�es par des virgules et le tout est mis entre crochets.
Dans le futur, il pourra �tre envisag� d'automatiser la cr�ation de ce fichier.


- infos.dat : ce fichier sera de la m�me forme que graph.dat, si ce n'est que le premier �l�ment doit �tre dans le premier graphe, le second est soit HTMLType (pour lier une page et un style, voir plus bas), soit Description (le dernier param�tre sera alors un texte, soit Image (le dernier param�tre sera alors le lien vers une image).
le deuxi�me �l�ment n'est pas entre guillemets.
Dans le futur, il sera possible d'ajouter d'autres options pour le deuxi�me �l�ment.

- style.dat : ce fichier d�crit les pages HTML qui seront g�n�r�es.
Chaque style est compos� d'un nom (entre guillemets) et d'un noeud, qui contient l'ensemble de la page. Chaque style est entre parenth�ses et ils sont s�par�s par des virgules, l'ensemble est entre crochets.
Plusieurs types de noeuds sont possibles:

Node nom [Parameter] [Style] -> repr�sente une balise HTML. nom est le nom de la balise entre guillemets, [Parameter] est une liste d'attributs de la balise comme d�crit plus bas, et Style est une liste des Noeuds qui seront dans la balise.
Text texte -> ins�re un texte de votre choix
Title  -> ins�re le titre de la page
IterateRelation [Style]  -> permet de reproduire une fois par relation la s�rie de balise contenue
LinkName -> permet d'ins�rer le nom de la premi�re relation active. Utilisable dans un noeud IterateRelation
LinkTarget -> permet d'ins�rer la cible de la premi�re relation active. Utilisable dans un noeud IterateRelation 
IterateInfos Type [Style] -> permet de reproduire une fois par �l�ment du fichier info du type pr�cis� la s�rie de balise contenue
Info -> permet d'ins�rer la cible de la premi�re Info active. Utilisable dans un noeud IterateInfos


Les attributs peuvent �tre �crits de ces mani�res:
Param String String -> pour un attribut fixe, en premier le nom de l'attribut en second la valeur
Link String         -> la valeur de l'attribut est la cible de la premi�re relation active � laquelle est ajout� un .html, afin de cr�er un lien. Utilisable dans un noeud IterateRelation
TitleP String       -> la valeur de l'attribut est le nom de la page
InfoP String        -> la valeur de l'attribut est la cible de la premi�re Info active. Utilisable dans un noeud IterateInfos