const images = require.context('../images', true)

import "@hotwired/turbo-rails"

import LocalTime from 'local-time'
LocalTime.start()

import '../controllers'

import "stylesheets/application.scss"
