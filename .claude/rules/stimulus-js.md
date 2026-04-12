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
