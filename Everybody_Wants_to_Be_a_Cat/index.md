---
basename: Everybody_Wants_to_Be_a_Cat
parts:
  - Soprano
  - Alto
  - Baritone
  - Bass
  - Mezzo-soprano

---
<link rel="stylesheet" href="css/main.css">

# Every body wants to be a cat

<div class="media-scroller">
{% for i in (1..10) %}
{% assign sheetnumber = i | prepend: '0' | slice: -2, 2 %}
  <div class="media-element">
  <img src="{{page.basename}}-Partitura-{{ sheetnumber }}.svg" alt="">
  </div>
{% endfor %}
</div>

[XMLPlay](../xmlplay.html?Everybody_Wants_to_Be_a_Cat/Everybody_Wants_to_Be_a_Cat.xml)

<a href="../xmlplay.html?Everybody_Wants_to_Be_a_Cat/Everybody_Wants_to_Be_a_Cat.xml">Everybody_Wants_to_Be_a_Cat</a>

## Part files

{% for p in page.parts %}
### {{ p }}

[note part]({{page.basename}}-{{ p }}-1.svg) [MP3]({{page.basename}}-{{ p }}.mp3)

{% endfor %}
