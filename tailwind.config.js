const colors = require('tailwindcss/colors')
const defaultTheme = require('tailwindcss/defaultTheme')

function withOpacityValue(variable) {
  return ({ opacityValue }) => {
    if (opacityValue === undefined) {
      return `rgb(var(${variable}))`
    }
    return `rgb(var(${variable}) / ${opacityValue})`
  }
}

module.exports = {
  mode: 'jit',
  content: [
    './app/components/**/*.html.erb',
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.{js,jsx,ts,tsx}',
    './client/**/*.{js,jsx,ts,tsx}',
    './spec/stories/**/*.rb',
    './stories/**/*.{js,jsx,mdx,ts,tsx}'
  ],
  darkMode: 'class',
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',

      blue: colors.blue,
      indigo: colors.indigo,
      sky: colors.sky,
      gray: colors.gray,
      zinc: colors.zinc,
      red: colors.red,
      green: colors.green,
      yellow: colors.yellow,
      orange: colors.orange,
      purple: colors.purple,
      amber: colors.amber,
      white: colors.white,
      black: colors.black,
      slate: colors.slate
    },
    extend: {
      colors: {
        primary: withOpacityValue('--color-primary-dark'),
        'on-primary': withOpacityValue('--color-on-primary-dark'),
        'primary-container': withOpacityValue('--color-primary-container-dark'),
        'on-primary-container': withOpacityValue(
          '--color-on-primary-container-dark'
        ),
        secondary: withOpacityValue('--color-secondary-dark'),
        'on-secondary': withOpacityValue('--color-on-secondary-dark'),
        'secondary-container': withOpacityValue(
          '--color-secondary-container-dark'
        ),
        'on-secondary-container': withOpacityValue(
          '--color-on-secondary-container-dark'
        ),
        tertiary: withOpacityValue('--color-tertiary-dark'),
        'on-tertiary': withOpacityValue('--color-on-tertiary-dark'),
        'tertiary-container': withOpacityValue(
          '--color-tertiary-container-dark'
        ),
        'on-tertiary-container': withOpacityValue(
          '--color-on-tertiary-container-dark'
        ),
        error: withOpacityValue('--color-error-dark'),
        'on-error': withOpacityValue('--color-on-error-dark'),
        'error-container': withOpacityValue('--color-error-container-dark'),
        'on-error-container': withOpacityValue(
          '--color-on-error-container-dark'
        ),
        outline: withOpacityValue('--color-outline-dark'),
        background: withOpacityValue('--color-background-dark'),
        'on-background': withOpacityValue('--color-on-background-dark'),
        surface: withOpacityValue('--color-surface-dark'),
        'surface-1': withOpacityValue('--color-surface-dark-1'),
        'surface-2': withOpacityValue('--color-surface-dark-2'),
        'surface-3': withOpacityValue('--color-surface-dark-3'),
        'surface-4': withOpacityValue('--color-surface-dark-4'),
        'surface-5': withOpacityValue('--color-surface-dark-5'),
        'on-surface': withOpacityValue('--color-on-surface-dark'),
        'surface-variant': withOpacityValue('--color-surface-variant-dark'),
        'surface-variant-1': withOpacityValue('--color-surface-variant-dark-1'),
        'surface-variant-2': withOpacityValue('--color-surface-variant-dark-2'),
        'surface-variant-3': withOpacityValue('--color-surface-variant-dark-3'),
        'surface-variant-4': withOpacityValue('--color-surface-variant-dark-4'),
        'surface-variant-5': withOpacityValue('--color-surface-variant-dark-5'),
        'on-surface-variant': withOpacityValue(
          '--color-on-surface-variant-dark'
        ),
        'inverse-surface': withOpacityValue('--color-inverse-surface-dark'),
        'inverse-on-surface': withOpacityValue(
          '--color-inverse-on-surface-dark'
        )
      },
      opacity: {
        8: '.08',
        12: '.12'
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],

        'display-large': 'var(--typescale-display-large-font)',
        'display-medium': 'var(--typescale-display-medium-font)',
        'display-small': 'var(--typescale-display-small-font)',
        'headline-large': 'var(--typescale-headline-large-font)',
        'headline-medium': 'var(--typescale-headline-medium-font)',
        'headline-small': 'var(--typescale-headline-small-font)',
        'title-large': 'var(--typescale-title-large-font)',
        'title-medium': 'var(--typescale-title-medium-font)',
        'title-small': 'var(--typescale-title-small-font)',
        'label-large': 'var(--typescale-label-large-font)',
        'label-medium': 'var(--typescale-label-medium-font)',
        'label-small': 'var(--typescale-label-small-font)',
        'body-large': 'var(--typescale-body-large-font)',
        'body-medium': 'var(--typescale-body-medium-font)',
        'body-small': 'var(--typescale-body-small-font)'
      },
      fontSize: {
        'display-large': [
          'var(--typescale-display-large-size)',
          {
            letterSpacing: 'var(--typescale-display-large-tracking)',
            lineHeight: 'var(--typescale-display-large-line-height)'
          }
        ],
        'display-medium': [
          'var(--typescale-display-medium-size)',
          {
            lineHeight: 'var(--typescale-display-medium-line-height)'
          }
        ],
        'display-small': [
          'var(--typescale-display-small-size)',
          {
            letterSpacing: 'var(--typescale-display-small-tracking)',
            lineHeight: 'var(--typescale-display-small-line-height)'
          }
        ],
        'headline-large': [
          'var(--typescale-headline-large-size)',
          {
            letterSpacing: 'var(--typescale-headline-large-tracking)',
            lineHeight: 'var(--typescale-headline-large-line-height)'
          }
        ],
        'headline-medium': [
          'var(--typescale-headline-medium-size)',
          {
            letterSpacing: 'var(--typescale-headline-medium-tracking)',
            lineHeight: 'var(--typescale-headline-medium-line-height)'
          }
        ],
        'headline-small': [
          'var(--typescale-headline-small-size)',
          {
            letterSpacing: 'var(--typescale-headline-small-tracking)',
            lineHeight: 'var(--typescale-headline-small-line-height)'
          }
        ],
        'title-large': [
          'var(--typescale-title-large-size)',
          {
            letterSpacing: 'var(--typescale-title-large-tracking)',
            lineHeight: 'var(--typescale-title-large-line-height)'
          }
        ],
        'title-medium': [
          'var(--typescale-title-medium-size)',
          {
            letterSpacing: 'var(--typescale-title-medium-tracking)',
            lineHeight: 'var(--typescale-title-medium-line-height)'
          }
        ],
        'title-small': [
          'var(--typescale-title-small-size)',
          {
            letterSpacing: 'var(--typescale-title-small-tracking)',
            lineHeight: 'var(--typescale-title-small-line-height)'
          }
        ],
        'label-large': [
          'var(--typescale-label-large-size)',
          {
            letterSpacing: 'var(--typescale-label-large-tracking)',
            lineHeight: 'var(--typescale-label-large-line-height)'
          }
        ],
        'label-medium': [
          'var(--typescale-label-medium-size)',
          {
            letterSpacing: 'var(--typescale-label-medium-tracking)',
            lineHeight: 'var(--typescale-label-medium-line-height)'
          }
        ],
        'label-small': [
          'var(--typescale-label-small-size)',
          {
            letterSpacing: 'var(--typescale-label-small-tracking)',
            lineHeight: 'var(--typescale-label-small-line-height)'
          }
        ],
        'body-large': [
          'var(--typescale-body-large-size)',
          {
            letterSpacing: 'var(--typescale-body-large-tracking)',
            lineHeight: 'var(--typescale-body-large-line-height)'
          }
        ],
        'body-medium': [
          'var(--typescale-body-medium-size)',
          {
            letterSpacing: 'var(--typescale-body-medium-tracking)',
            lineHeight: 'var(--typescale-body-medium-line-height)'
          }
        ],
        'body-small': [
          'var(--typescale-body-small-size)',
          {
            letterSpacing: 'var(--typescale-body-small-tracking)',
            lineHeight: 'var(--typescale-body-small-line-height)'
          }
        ]
      }
    }
  },
  plugins: [
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/typography')
  ]
}
