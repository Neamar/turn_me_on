# WHAT?

Samsung displays colored emojis by default, disrespecting the Variation Selector 16. Clearly, Samsung read the Unicode manual and though "fuck this I'm smarter than this shit".

I shit on Samsung.

Anyway, I needed to get some emojis properly displayed, without Samsung's crap on top of it, so I set up my own font to do the rendering, bypassing Samsung default system font.

However, this font is huge. Now, flutter apps are already fairly large by default, so there is no point bloating each device with 6 useless MB, so I'm generating a subset of my font for use within the app, and keeping the original file in case I need to get more symbols later.

I'm using fonttools to generate the new font:

Current subset of characters I need: `☯·∞↓↑↕Ω∑⇧`.
Converted to hexadecimal, this is:

```
pyftsubset NotoSansTC-Regular.otf \
      --unicodes=U+262F,U+B7,U+221E,U+2193,U+2191,U+2195,U+03A9,U+2211,U+21E7 \
      --output-file=NotoSansTC-Regular-stripped.ttf
```
