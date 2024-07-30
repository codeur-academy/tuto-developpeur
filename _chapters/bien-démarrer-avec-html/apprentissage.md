---
reference: apprentissage-bien-démarrer-avec-html
slug: apprentissage
concept: ''
title: Apprentissage
description: Introduction à la phase d'apprentissage
order: 3
part_reference: bien-démarrer-avec-html
directory: bien-démarrer-avec-html
permalink: bien-démarrer-avec-html/apprentissage
layout: chapters
phase: ''
---

## Apprentissage : auto-formation 

pour réaliser le mini-projet : **Ma première page web : Découvre l'ordinateur !**
il vous faudra maîtriser ces notions essentielles : 

{% assign chapters = site.chapters | where: 'part_reference', page.part_reference  | where_exp:  'item', "item.concept != ''" | sort: 'order' %}


{% for chapter in chapters %}

- [{{chapter.title}}]({{site.baseurl}}{{chapter.url}})

{% endfor %}

Chaque concept sera abordé à travers des tutoriels en ligne clairs et progressifs.  Après chaque étape, vous aurez l'opportunité de mettre en pratique vos nouvelles connaissances en réalisant des exercices concrets directement liés à votre projet.