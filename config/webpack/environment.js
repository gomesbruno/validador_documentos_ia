// config/webpack/environment.js
const { environment } = require('@rails/webpacker')
const webpack = require('webpack')

environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    'window.jQuery': 'jquery',
    Popper: ['popper.js', 'default']
  })
)

environment.loaders.append('fonts', {
  test: /\.(woff|woff2|eot|ttf|otf)$/i,
  use: [{ loader: 'file-loader', options: { name: '[name]-[hash].[ext]', outputPath: 'media/fonts' } }]
})

module.exports = environment
