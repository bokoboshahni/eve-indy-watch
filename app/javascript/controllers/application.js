import { Application } from "@hotwired/stimulus"
import { definitionsFromContext } from "@hotwired/stimulus-webpack-helpers"

const application = Application.start()
const context = require.context(".", true, /\.js$/)
application.load(definitionsFromContext(context))

const componentContext = require.context("../../components/", true, /(.*)\/.+\.js$/);
application.load(definitionsFromContext(componentContext));

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }
