import { application } from "hyper_kitten_meow/controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("hyper_kitten_meow/controllers", application)

console.log("Hello from Stimulus", application)
