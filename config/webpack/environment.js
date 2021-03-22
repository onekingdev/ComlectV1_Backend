const { environment } = require('@rails/webpacker')

const { VueLoaderPlugin } = require('vue-loader')
const path = require('path')

environment.plugins.prepend(
    'VueLoaderPlugin',
    new VueLoaderPlugin()
)

environment.loaders.prepend('vue', {
    test: /\.vue$/,
    use: [{
        loader: 'vue-loader',
    }]
})

environment.loaders.prepend('css', {
    test: /\.css$/,
    use: ['style-loader', 'css-loader']
})

environment.loaders.prepend('scss', {
    test: /\.scss$/,
    use: [
        'vue-style-loader',
        'css-loader',
        'sass-loader'
    ]
})

environment.loaders.prepend('pug', {
    test: /\.pug$/,
    use: [{
        loader: 'pug-plain-loader'
    }]
})

environment.config.merge({
    resolve: {
        alias: {
            '@': path.resolve(__dirname, '..', '..', 'app/javascript/packs/vue'),
            'vue$': 'vue/dist/vue.esm.js'
        }
    }
})

module.exports = environment
