import "@hotwired/turbo-rails"
import "@hotwired/stimulus"
import "@rails/actiontext"
import "@rails/activestorage"
import * as bootstrap from "bootstrap"
import "hyper_kitten_meow/controllers"

// Hack to appease Popper
window.process = { env: {} }
