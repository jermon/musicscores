---
basename: Everybody_Wants_to_Be_a_Cat
parts:
  - Soprano
  - Alto
  - Baritone
  - Bass
  - Mezzo-soprano
  - 

---
# Every body wants to be a cat

{% for i in (1..10) %}
{% assign sheetnumber = i | prepend: '0' | slice: -2, 2 %}
![{{page.basename}}-Partitura-{{ sheetnumber }}.svg]({{page.basename}}-Partitura-{{ sheetnumber }}.svg)

{% endfor %}


## Part files

{% for p in page.parts %}
### {{ p }}

[note part]({{page.basename}}-{{ p }}-01.svg) 

[MP3]({{page.basename}}-{{ p }}.mp3)

{% endfor %}
