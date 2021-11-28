const images = require.context('../images', true)

import "@hotwired/turbo-rails"

import LocalTime from 'local-time'
import "stylesheets/application.scss"

LocalTime.start()

import '../controllers'
