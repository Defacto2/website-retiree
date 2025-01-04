# /lib/fontawesomepro/README.md

[Font Awesome downloads](https://fontawesome.com/download)

#### Font Awesome 5 PRO is commercial software and cannot be distributed with open sourced projects.

| Style  | Availability | Style Prefix |
| ------ | ------------ | ------------ |
| Solid  | Free         | `fas`        |
| Brands | Free         | `fab`        |
| Light  | Pro          | `fal`        |

Example:

```html
<i class="fas fa-camera"></i>

<i class="fab fa-font-awesome"></i>
```

| Files & folders | What they are                | Where you should start |
| --------------- | ---------------------------- | ---------------------- |
| `/css`          | Stylesheets for Web Fonts    | `all.css`              |
| `/js`           | SVG with JS                  | `all.js`               |
| `/less`         | Less pre-processor           | `fontawesome.less`     |
| `/scss`         | Sass pre-processor           | `fontawesome.scss`     |
| `/sprites`      | SVG sprites                  | `solid.svg`            |
| `/svgs`         | Individual SVG for each icon |                        |
| `/webfonts`     | Web Font files used with CSS | See `/css`             |

### Using Web Fonts with CSS

```html
<head>
  <link href="/your-path-to-fontawesome/css/all.css" rel="stylesheet" />
  <!--load all styles -->
</head>
<body>
  <i class="fas fa-user"></i>
  <!-- uses solid style -->
</body>
```

### Using SVG with JS

```html
<head>
  <script defer src="/your-path-to-fontawesome/js/all.js"></script>
  <!--load all styles -->
</head>
<body>
  <i class="fas fa-user"></i>
  <!-- uses solid style -->
</body>
```

### Customisation

```html
<head>
  <!-- reference your copy Font Awesome here (from our CDN or by hosting yourself) -->
  <link href="/your-path-to-fontawesome/css/fontawesome.css" rel="stylesheet" />
  <link href="/your-path-to-fontawesome/css/brands.css" rel="stylesheet" />
  <link href="/your-path-to-fontawesome/css/solid.css" rel="stylesheet" />
  <style type="text/css">
    // custom styling for all icons
    i.fas,
    i.fab {
      border: 1px solid red;
    }
    // custom styling for specific icons
    .fa-fish {
      color: salmon;
    }
    .fa-frog {
      color: green;
    }
    .fa-user-ninja.vanished {
      opacity: 0;
    }
    .fa-facebook {
      color: rgb(59, 91, 152);
    }
  </style>
</head>
<body>
  <i class="fas fa-fish"></i>
  <i class="fas fa-frog"></i>
  <i class="fas fa-user-ninja vanished"></i>
  <i class="fab fa-facebook"></i>
</body>
```

### SVG+JS Scaling, flip and rotate

https://fontawesome.com/how-to-use/on-the-web/styling/power-transforms

```html
<!-- Scaling -->
<div class="fa-4x">
  <i
    class="fas fa-seedling"
    data-fa-transform="shrink-8"
    style="background:MistyRose"
  ></i>
  <i class="fas fa-seedling" style="background:MistyRose"></i>
  <i
    class="fas fa-seedling"
    data-fa-transform="grow-6"
    style="background:MistyRose"
  ></i>
</div>

<!-- Rotating and flipping -->
<div class="fa-4x">
  <i
    class="fas fa-seedling"
    data-fa-transform="rotate-180"
    style="background:MistyRose"
  ></i>
  <i
    class="fas fa-seedling"
    data-fa-transform="flip-v"
    style="background:MistyRose"
  ></i>
  <i
    class="fas fa-seedling"
    data-fa-transform="flip-h"
    style="background:MistyRose"
  ></i>
  <i
    class="fas fa-seedling"
    data-fa-transform="flip-v flip-h"
    style="background:MistyRose"
  ></i>
</div>
```

### SVG+JS Masking

https://fontawesome.com/how-to-use/on-the-web/styling/masking

```html
<div class="fa-4x">
  <i
    class="fas fa-pencil-alt"
    data-fa-transform="shrink-10 up-.5"
    data-fa-mask="fas fa-comment"
    style="background:MistyRose"
  ></i>
  <i
    class="fab fa-facebook-f"
    data-fa-transform="shrink-3.5 down-1.6 right-1.25"
    data-fa-mask="fas fa-circle"
    style="background:MistyRose"
  ></i>
  <i
    class="fas fa-headphones"
    data-fa-transform="shrink-6"
    data-fa-mask="fas fa-square"
    style="background:MistyRose"
  ></i>
  <i
    class="fas fa-mask"
    data-fa-transform="shrink-3 up-1"
    data-fa-mask="fas fa-circle"
    style="background:MistyRose"
  ></i>
</div>

<div class="fa-4x">
  <i
    class="fas fa-pen-alt"
    data-fa-transform="shrink-10 up-.5"
    data-fa-mask="fas fa-comment"
    data-fa-mask-id="comment"
    style="background:MistyRose"
  ></i>
</div>
```

### SVG+JS Layering, text and counters

https://fontawesome.com/how-to-use/on-the-web/styling/layering

```HTML
<div class="fa-4x">
  <span class="fa-layers fa-fw" style="background:MistyRose">
    <i class="fas fa-circle" style="color:Tomato"></i>
    <i class="fa-inverse fas fa-times" data-fa-transform="shrink-6"></i>
  </span>

  <span class="fa-layers fa-fw" style="background:MistyRose">
    <i class="fas fa-bookmark"></i>
    <i class="fa-inverse fas fa-heart" data-fa-transform="shrink-10 up-2" style="color:Tomato"></i>
  </span>

  <span class="fa-layers fa-fw" style="background:MistyRose">
    <i class="fas fa-play" data-fa-transform="rotate--90 grow-2"></i>
    <i class="fas fa-sun fa-inverse" data-fa-transform="shrink-10 up-2"></i>
    <i class="fas fa-moon fa-inverse" data-fa-transform="shrink-11 down-4.2 left-4"></i>
    <i class="fas fa-star fa-inverse" data-fa-transform="shrink-11 down-4.2 right-4"></i>
  </span>

  <span class="fa-layers fa-fw" style="background:MistyRose">
    <i class="fas fa-calendar"></i>
    <span class="fa-layers-text fa-inverse" data-fa-transform="shrink-8 down-3" style="font-weight:900">27</span>
  </span>

  <span class="fa-layers fa-fw" style="background:MistyRose">
    <i class="fas fa-certificate"></i>
    <span class="fa-layers-text fa-inverse" data-fa-transform="shrink-11.5 rotate--30" style="font-weight:900">NEW</span>
  </span>

  <span class="fa-layers fa-fw" style="background:MistyRose">
    <i class="fas fa-envelope"></i>
    <span class="fa-layers-counter" style="background:Tomato">1,419</span>
  </span>
</div>
```

### SVG+JS, Improve performance

https://fontawesome.com/how-to-use/on-the-web/advanced/svg-symbols

```html
<!-- Name symbols with the value of data-fa-symbol, this is hidden -->
<i data-fa-symbol="picture-taker" class="fas fa-camera"></i>

<!-- Use the defined name -->
<svg><use xlink:href="#picture-taker"></use></svg>
```

### SVG+JS, Improve performance and styling

```html
<!-- A quick, reasonable place to start with styling your symbols -->
<style>
  .icon {
    width: 1em;
    height: 1em;
    vertical-align: -0.125em;
  }
</style>

<!-- Name symbols with the value of data-fa-symbol -->
<i data-fa-symbol="picture-taker" class="fas fa-camera"></i>

<!-- Use the defined name -->
<svg class="icon"><use xlink:href="#picture-taker"></use></svg> Who doesn't like
wafels?
```

### SVG+JS, Accessibility

Font Awesome has an in built auto-accessibility feature.

```html
<!-- use semantic meanings -->
<i title="Magic is included!" class="fas fa-magic"></i>
<i title="Magic is included!" data-fa-title-id="magic" class="fas fa-magic"></i>

<!-- decorative -->
<i class="fas fa-magic"></i>
<i data-fa-title-id="magic" class="fas fa-magic"></i>
```

### CSS sizing

Scaling details

- `xs` = .75em
- `sm` = .875em
- `lg` = 1.33em
- `2x` = 2em
- `10x` = 10em

```html
<i class="fas fa-camera fa-xs"></i>
<i class="fas fa-camera fa-sm"></i>
<i class="fas fa-camera fa-lg"></i>
<i class="fas fa-camera fa-2x"></i>
...
<i class="fas fa-camera fa-10x"></i>
```

### CSS stacked icons

```html
<span class="fa-stack fa-2x">
  <i class="fas fa-square fa-stack-2x"></i>
  <i class="fas fa-terminal fa-stack-1x fa-inverse"></i>
</span>

<span class="fa-stack fa-2x">
  <i class="fas fa-camera fa-stack-1x"></i>
  <i class="fas fa-ban fa-stack-2x" style="color:Tomato"></i>
</span>
```
