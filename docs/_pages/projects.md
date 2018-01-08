---
title: "Projects"
excerpt: "Projects"
permalink: /projects
---
Are you using one of my Projects Commercially ? {{ site.btn_paypal }}
<div class="grid__wrapper">
  {% for post in site.projects %}
    {% include archive-single.html type="grid" %}
  {% endfor %}
</div>
