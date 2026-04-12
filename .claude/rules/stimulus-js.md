---
paths:
  - "app/javascript/**/*.js"
---

# Stimulus Controller Standards

- Use ES6 syntax (arrow functions, destructuring).
- Add a comment at the top explaining purpose and usage example.
- Define `static targets`, `values`, `classes` at the top of the class.
- Initialize in `connect()`, clean up in `disconnect()`.
- Document values with types and defaults.
- Keep actions focused on a single responsibility.
- Prefer toggling classes over DOM manipulation.
- Use `data-controller`, `data-action`, `data-[controller]-target` attributes.
- Never use `document.getElementById()` or `document.querySelector()` for controller-owned elements.

## Flowbite Components

- Use Flowbite's Modal, Dropdown, Tooltip — never rebuild from scratch.
- Call `initFlowbite()` after Turbo renders new content containing Flowbite components.

## Turbo Integration

- Ensure controllers work with Turbo morphs and full page visits.
- Use custom Turbo Stream actions for UI operations (`close_modal`, `scroll_to`, `reset_form`).
- Never block Turbo navigation with synchronous JavaScript.

## Server-Side Rendering First

JS is a heavier liability than server code: the runtime environment is uncontrollable (browser versions/OS/network), production JS is unobservable by default, and the ecosystem favors progress over stability. Therefore:

- **Default approach** is server-side rendering + Turbo + Stimulus.
- JAM Stack / rich client only for "single-point strong needs" (drag-and-drop, real-time scanning) used locally.
- **One application uses one JS framework only** — never mix React and Vue, or run Stimulus and React simultaneously in the same app.

## Turbo Lifecycle

- Listen for `turbo:load`, not `DOMContentLoaded`. Turbo hijacks link navigation — `DOMContentLoaded` only fires on the initial visit.
- Adjust progress bar delay to 100ms (human perception threshold for causality): `Turbo.config.drive.progressBarDelay = 100`.

## Custom Elements as a Viable Alternative

When something exceeds Stimulus's capabilities but doesn't warrant a framework, use Web Components. Native API code can run stably for years, unaffected by Rails frontend toolchain changes.

### Custom Element Implementation Notes

- Use **named private methods** for event listeners, not anonymous functions. `connectedCallback` may be called multiple times (when elements are moved) — named methods won't double-bind, anonymous functions will.

```javascript
connectedCallback() {
  this.querySelectorAll("form").forEach(f => f.addEventListener("submit", this.#submitRating))
}

#submitRating = (event) => { /* ... */ }
```

- Express state through attributes; **CSS attribute selectors drive display**, JS only changes the attribute:

```css
widget-rating [role=status] { display: none; }
widget-rating[rating] [role=status] { display: block; }
```

Unidirectional data flow: JS → attribute → CSS → visual state. Clean separation of concerns.
