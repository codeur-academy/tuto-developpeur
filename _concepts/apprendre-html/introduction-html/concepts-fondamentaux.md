---
reference: concepts-fondamentaux-apprendre-html
slug: concepts-fondamentaux
self_learning: apprendre-html
concept_categories: introduction-html
tutorials:
- html-w3schools-html-introduction
title: Concepts fondamentaux
title_en: Fundamental Concepts
sujet: |-
  - Qu'est-ce qu'un Élément HTML ?
  - Structure d'une Page HTML
description: Apprendre les éléments de base d'un document HTML, tels que <html>, <head>
  et <body>, et comprendre la structure et la syntaxe du code HTML.
learning_order: ''
order: 2
directory: apprendre-html/introduction-html
layout: concepts
Todo: ''
sujets:
- Qu'est
- ce qu'un Élément HTML ?
- Structure d'une Page HTML
---

## La structure de base d'une page HTML

Une page HTML se compose de deux parties principales : l'en-tête (`<head>`) et le corps (`<body>`).

* **L'en-tête (`<head>`)** : Cette partie contient des informations sur la page qui ne sont pas directement affichées à l'écran, mais qui sont importantes pour les navigateurs et les moteurs de recherche. 
  * **`<title>`:** Définit le titre de la page, qui s'affiche dans la barre de titre du navigateur.
  * **`<meta>`:** Fournit des métadonnées sur la page, comme l'encodage des caractères, la description, les mots-clés, etc.

* **Le corps (`<body>`):** Cette partie contient le contenu visible de la page, c'est-à-dire tout ce que l'utilisateur voit à l'écran.


* **`<!DOCTYPE html>`:** Cette déclaration indique au navigateur qu'il s'agit d'un document HTML5.


## Un exemple concret

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Ma première page HTML</title>
</head>
<body>
  <h1>Bienvenue sur ma page !</h1>
  <p>Ceci est un paragraphe. Je peux y écrire tout ce que je veux.</p>
</body>
</html>
```

### Explication des éléments :
* **`<!DOCTYPE html>`:** Indique au navigateur qu'il doit interpréter le document comme une page HTML5.
* **`<html>`:** Élément racine qui englobe tout le contenu de la page.
* **`<head>`:** Contient les métadonnées de la page.
* **`<title>`:** Définit le titre de la page.
* **`<body>`:** Contient le contenu visible de la page.
* **`<h1>`:** Définit un titre de niveau 1.
* **`<p>`:** Définit un paragraphe.

### Pourquoi cette structure est-elle importante ?

* **Lisibilité:** Elle permet de structurer le code de manière claire et logique.
* **Compatibilité:** Les navigateurs s'attendent à cette structure pour afficher correctement la page.
* **SEO:** Les moteurs de recherche utilisent cette structure pour comprendre le contenu de la page.

**En résumé,** cette structure minimale vous donne les bases pour créer vos premières pages web. En ajoutant progressivement des éléments.