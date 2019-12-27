const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
environment.plugins.append('Provider',
    new webpack.ProvidePlugin({
        $: 'jquery/src/jquery',
        jQuery: 'jquery/src/jquery'
    })
)

module.exports = environment
