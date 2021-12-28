const images = require.context('../images', true)

import "@hotwired/turbo-rails"

import LocalTime from 'local-time'

import 'chartkick/chart.js'

LocalTime.start()

import '../controllers'

import "stylesheets/application.scss"
