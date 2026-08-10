pin "@hotwired/turbo-rails", to: "https://ga.jspm.io/npm:@hotwired/turbo-rails@8.0.20/app/javascript/turbo/index.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js"
pin "lexxy", to: "lexxy.js"

pin_all_from HyperKittenMeow::Engine.root.join("app/assets/javascripts/hyper_kitten_meow/controllers"), under: "hyper_kitten_meow/controllers"
pin "hyper_kitten_meow/application"
pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@7.0.4/app/assets/javascripts/activestorage.esm.js"
pin "@hotwired/turbo", to: "https://ga.jspm.io/npm:@hotwired/turbo@8.0.20/dist/turbo.es2017-esm.js"
pin "@rails/actioncable/src", to: "https://ga.jspm.io/npm:@rails/actioncable@8.0.0/src/index.js"
