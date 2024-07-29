---
layout : chapters
part_reference: auto-apprentissage
title : Apprendre HTML
slug: apprendre-html
order : 1
---

# Apprendre HTML

 

{% assign self_learnings = site.self_learnings | sort: 'order' %}

{% for self_learning in self_learnings  %}
- [{{self_learning.title}}]({{site.baseurl}}{{self_learning.url}})
{%- endfor -%}





{% assign concept_categories = site.concept_categories | where: 'self_learning' , "apprendre-html" | sort: 'order' %}

{% for concept_category in concept_categories  %}


{% assign concepts = site.concepts | where: 'concept_categories' , concept_category.reference | sort: 'order' %}

## {{concept_category.title}}


{% for concept in concepts %}
- [{{concept.title}}]({{site.baseurl}}{{concept.url}})
{%- endfor -%}

{%- endfor -%}