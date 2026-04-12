# Controllers

Default template controllers can live in `lib/template_base/app/controllers`.

Copy a controller into `app/controllers` before customizing it:

```bash
bin/rails generate template_base:override app/controllers/users/omniauth_callbacks_controller.rb
```
