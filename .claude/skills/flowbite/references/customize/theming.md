# Theming

Use the theming options from Tailwind CSS to set native CSS theme variables to add new colors, fonts, spacings and create new utility classes to customize your project

Since the release of Tailwind v4 the theming customization has been moved from the `tailwind.config.js` file to native CSS theme variables which brings an advantage that allows your project to have a much more natural way of customizing colors, fonts, shadows, spacings, and more.

Check out the new [custom variables](/docs/customize/variables) from the Flowbite design system to make it easier to customize your project.

## Flowbite Plugin

After installing Flowbite, make sure that you also import the Flowbite plugin in your main CSS file:

```css
/* input.css file */
@import "tailwindcss";

@plugin "flowbite/plugin";
@source "../node_modules/flowbite";
```

This will ensure that the pseudo styles for forms, checkboxes, tooltips, charts, and datatables will be applied.

## Theme options

The best way to understand how theming works with Tailwind CSS is for example when you're adding a new color variable this will be available for all text, background, and border related colors. Basically the newly added color will propagate into all of the available utility classes.

There are many more variable namespaces that you can use to customize the default utility classes from Tailwind CSS including for spacing, containers, fonts, sizing, and more.

### Colors

Updating or adding new colors can be done by using the `--color-{name}` variable namespaces:

```css
/* input.css file */
@import "tailwindcss";

@plugin "flowbite/plugin";
@source "../node_modules/flowbite";

@theme {
    --color-fg-brand-subtle: var(--color-blue-200);
    --color-fg-brand: var(--color-blue-700);
    --color-fg-brand-strong: var(--color-blue-900);

    --color-brand-softer: var(--color-blue-50);
    --color-brand-soft: var(--color-blue-100);
    --color-brand: var(--color-blue-700);
    --color-brand-medium: var(--color-blue-200);
    --color-brand-strong: var(--color-blue-800);
}
```

This introduces a list of colors attributed to the `brand` variable name, meaning that utility class names such as `text-fg-brand` or `bg-brand` will now show your custom branded color when using Tailwind.

### Fonts

You can add your own fonts by updating the `--font-body` variable in your CSS file.

```css
/* input.css file */
@import "tailwindcss";

@plugin "flowbite/plugin";
@source "../node_modules/flowbite";

@theme {
    --font-sans: 'Inter', 'ui-sans-serif', 'system-ui', '-apple-system', 'system-ui', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'Noto Sans', 'sans-serif', 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
    --font-body: 'Inter', 'ui-sans-serif', 'system-ui', '-apple-system', 'system-ui', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'Noto Sans', 'sans-serif', 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
    --font-mono: 'ui-monospace', 'SFMono-Regular', 'Menlo', 'Monaco', 'Consolas', 'Liberation Mono', 'Courier New', 'monospace';
}
```

Make sure that you apply `antialiased` to the `<body>` tag of your document to enable font smoothing.

### Spacing

Use the `spacing-{name}` variable namespace to set spacing values to utility class names used for setting widths, heights, paddings, margins, and more.

```css
/* input.css file */
@import "tailwindcss";

@plugin "flowbite/plugin";
@source "../node_modules/flowbite";

@theme {
   --spacing-custom: 10px;
}
```

### Breakpoints

You can customize the breakpoints at which the reponsive mobile-first utility classes are being targeted using the `--breakpoint-{size}` variable namespaces in your main CSS file:

```css
/* input.css file */
@import "tailwindcss";

@plugin "flowbite/plugin";
@source "../node_modules/flowbite";

@theme {
  --breakpoint-xs: 30rem;
  --breakpoint-2xl: 100rem;
  --breakpoint-3xl: 120rem;
}
```

This will make `p-custom` or `w-custom` have the value of `10px` as explained above.

## Reference

You can read all of the configurable variable namespaces on the <a href="https://tailwindcss.com/docs/theme#theme-variable-namespaces" target="_blank" rel="nofollow">Tailwind CSS docs</a>.