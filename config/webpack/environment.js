const { environment } = require('@rails/webpacker')

module.exports = environment
=======
const webpack = require('webpack')
=======
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)

// Vue.js フル版（Compiler入り）
environment.config.resolve.alias = { 'vue$': 'vue/dist/vue.esm.js' }

// ここから
// jQueryとBootstapのJSを使えるように
const webpack = require('C:\nosakane\app\javascript\packs')
environment.plugins.prepend(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: 'popper.js'
  })
)

// ここまで

module.exports = environment