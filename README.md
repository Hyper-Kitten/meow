Meow!
===========

This is a very boring blogging platform based on Rails geared toward Rails developers. It has very little in the way of frills and is designed to get up and running fast with an easy to understand codebase.

Its built as a Rails Engine and therefore should be easy to customize and extend as you see fit.

This might not be good for you if:
----------------------------------

* You have many contributors and need role based permissions
* If you need to track changes in articles
* Make extensive use of images

Features
--------

* Tagging
* Basic user authentication
* Trix editing
* Basic slug management

That's about it for now, though I'm sure features will evolve slowy as needs are recognized through use.

Requirements
------------

This application is currently tested on Rails 7, Ruby 3.1 and the PostgreSQL database.

Setup
-----

Configuration is the same as a typical installation of a Rails Engine

* Create new Rails app
* Include `hyper-kitten-meow` gem by adding `gem 'hyper-kitten-meow'` to your Gemfile
* Mount the engine by adding `mount HyperKitten::Meow::Engine, at: "/blog"` to the routes file. You can also mount the engine to your project's root by adding `mount HyperKitten::Meow::Engine, at: "/"` instead.
* Install the migrations by running rake hyper_kitten_meow:install:migrations
* Run the migrations `rake db:migrate`
* Add an admin user by using the Rails console `rails hyper_kitten:meow:create_user`
* Set the values in the en.yml file to your liking

Customization
-------------

There currently is no theme in place, so the views will have to be styled themselves.

* Frontend views are where you would expect them to be. So:
  * app/views/layouts/hyper_kitten/meow/application.html.haml
  * app/views/hyper_kitten/meow

* Admin styles and markup are in the Admin namespace. So:
  * app/assets/stylesheets/hyper_kitten/meow/admin
  * app/views/layouts/hyper_kitten/meow/admin.html.haml
  * app/views/admin/hyper_kitten/meow

If you duplicate these files and directories in your project you can override the views and customize them however you like.

### Branding

The admin wordmark reads from the same `title` translation as the browser tab, so
setting it in your `en.yml` brands both:

```yaml
en:
  title: 'Susquehanna Footprints'
```

For a different mark, or no mark at all, override `sidebar_brand` in a
`Views::Admin::Base` subclass. It may return anything Phlex can render — a
component, a class, a proc, or a string — and `nil` keeps the engine wordmark:

```ruby
def sidebar_brand
  Components::Wordmark.new(text: "Susquehanna Footprints", mark: "sf-mark.svg", light: true)
end
```

Pass `light: true` for anything you render there: the sidebar is dark, and the
wordmark's default ink color is meant for light backgrounds. `mark: false` drops
the image and leaves the text alone.

If you render `Components::Sidebar` yourself, it takes the same thing as `brand:`.

### Icons

`Components::Icon` inlines an SVG by name: `render Components::Icon.new("calendar-days")`,
or `icon: "mic"` where components accept it. The whole [lucide](https://lucide.dev)
set ships with the engine, so any lucide name works with no setup.

To use your own glyph, or to override one of lucide's, drop `name.svg` into
`app/assets/images/icons` in your app — that directory is searched first. Names that
don't resolve render nothing, and log a warning in development and test.

To update the vendored set: `rake meow:icons:sync VERSION=1.31.0` (repo only, not
shipped in the gem).

### Static Pages

If you would like to add static pages to your site I recommend [High Voltage](https://github.com/thoughtbot/high_voltage "High Voltage"). 

Deployment instructions
-----------------------

You can deploy the app however you like, but I like [Heroku](http://heroku.com "Heroku"). Especially their [hobby plan](https://www.heroku.com/pricing "Heroku Pricing"). To deploy on Heroku:

* `heroku create [your app name]`
* `git push heroku master`
* `heroku run rake db:setup`
* Create your admin user in the console.
  * `heroku run rails console`
  * `rails hyper_kitten:meow:create_user`
* `heroku open`

Todo:
-----

* Figure out a clean and easy way to allow image uploads that doesn't complicate setup
* Add RSS support
* Add correct head parameters for SEO

Running the Test Suite
----------------------

`bin/rspec spec`

License
-------

This project rocks and uses MIT-LICENSE.


