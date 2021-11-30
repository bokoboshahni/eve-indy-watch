const images = require.context('../images', true)

import "@hotwired/turbo-rails"

import LocalTime from 'local-time'
import "stylesheets/application.scss"

import 'chartkick/chart.js'

LocalTime.start()

import '../controllers'
