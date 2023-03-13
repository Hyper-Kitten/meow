pin "bootstrap", to: "https://ga.jspm.io/npm:bootstrap@5.2.2/dist/js/bootstrap.esm.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.6/lib/index.js"
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js"
pin "quill", to: "https://ga.jspm.io/npm:quill@1.3.7/dist/quill.js"
pin "buffer", to: "https://ga.jspm.io/npm:@jspm/core@2.0.1/nodelibs/browser/buffer.js"

pin_all_from HyperKittenMeow::Engine.root.join("app/assets/javascripts/hyper_kitten_meow/controllers"), under: "hyper_kitten_meow/controllers"
pin "hyper_kitten_meow/application"
pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@7.0.4/app/assets/javascripts/activestorage.esm.js"
pin "@rails/actiontext", to: "https://ga.jspm.io/npm:@rails/actiontext@7.0.4/app/assets/javascripts/actiontext.js"
