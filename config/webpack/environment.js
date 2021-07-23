const { environment } = require('@rails/webpacker')
const { EnvironmentPlugin } = require('webpack');
const { VueLoaderPlugin } = require('vue-loader')
// const CleanWebpackPlugin = require("clean-webpack-plugin")
const path = require('path')

const dotenv = require('dotenv')
const result = dotenv.config()

if (result.error) {
  throw result.error
}
// console.log(result.parsed)

environment.plugins.prepend(
    'VueLoaderPlugin',
    new VueLoaderPlugin()
)

// environment.plugins.append(
//   "CleanWebpackPlugin",
//   new CleanWebpackPlugin(["packs"], {
//     root: path.resolve(__dirname, "../../public"),
//     verbose: true
//   })
// )

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

// environment.loaders.prepend('scss', {
//     test: /\.scss$/,
//     use: [
//         'vue-style-loader',
//         'css-loader',
//         'sass-loader'
//     ]
// })

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

environment.plugins.prepend(
  'Environment',
  new EnvironmentPlugin([
    'PLAID_PUBLIC_KEY',
    'STRIPE_PUBLISHABLE_KEY'
  ])
);

// module.exports = environment.toWebpackConfig()
module.exports = environment
