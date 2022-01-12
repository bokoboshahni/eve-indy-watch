const images = require.context('../images', true) // eslint-disable-line no-unused-vars

import '@hotwired/turbo-rails'

import LocalTime from 'local-time'
LocalTime.start()

import '../controllers'

import 'stylesheets/application.scss'
