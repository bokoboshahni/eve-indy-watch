const {environment} = require('@rails/webpacker')

// Get the actual sass-loader config
const sassLoader = environment.loaders.get('sass');
sassLoader.use.find(({ loader }) => loader === 'css-loader').options.sourceMap = false;

// Use Dart-implementation of Sass (default is node-sass)
const options = sassLoaderConfig.options
options.implementation = require('sass')

function hotfixPostcssLoaderConfig(subloader) {
  const subloaderName = subloader.loader
  if (subloaderName === 'postcss-loader') {
    subloader.options.postcssOptions = subloader.options.config
    delete subloader.options.config
  }
}

environment.loaders.keys().forEach(loaderName => {
const loader = environment.loaders.get(loaderName)
loader.use.forEach(hotfixPostcssLoaderConfig)
})

module.exports = environment
