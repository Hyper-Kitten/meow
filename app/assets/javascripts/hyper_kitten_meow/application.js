import "@hotwired/stimulus"
import "@rails/actiontext"
import "@rails/activestorage"
import "trix"
import * as bootstrap from "bootstrap"
import "hyper_kitten_meow/controllers"

// Hack to appease Popper
window.process = { env: {} }

console.log("Hello from HyperKittenMeow")
