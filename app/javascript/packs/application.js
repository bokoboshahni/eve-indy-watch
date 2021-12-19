const images = require.context('../images', true)

import "@hotwired/turbo-rails"

import LocalTime from 'local-time'
import "stylesheets/application.scss"

import 'chartkick/chart.js'
import * as d3 from 'd3'
import * as fc from 'd3fc'

LocalTime.start()

import '../controllers'
