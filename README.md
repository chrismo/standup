## Contributors

chrismo, eki, jdodson

## Development Database

`bundle exec rails db:reset` depends on `STANDUP_PRODUCTION_DATABASE_URL` being
set.

## Production Migrations

Production migrations are still run from a dev box:

`RAILS_ENV=production bin/rails db:migrate`

This depends on `STANDUP_PRODUCTION_DATABASE_URL` being set. 

## TODO

### Notes on tools for admin-y type jumpstarts. 

So far just building it out myself though. Interested in learning about CSS Grid
and Flexbox, and seeing how far we can go without any gems, etc.

https://github.com/bparanj/ckl - sample code for ajax-y list view. I need to do 
some of this work to make this all go faster, auto-suggest categories and sizes
and distribute the work to the team.    

http://rubyjunky.com/creating-rails-admin-pages-from-scratch-part-1-index.html
