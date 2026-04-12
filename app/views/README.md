# Customizing Views

Template defaults can live in `lib/template_base/app/views`.

To customize a base view, copy it into `app/views` with:

```bash
bin/rails generate template_base:override app/views/layouts/application.html.erb
```
