// vue.config.js
const path = require('path')

module.exports = {
    devServer: {
        proxy: 'http://192.168.1.132:8000/api'
    },
    chainWebpack: config => {
        const types = ['vue-modules', 'vue', 'normal-modules', 'normal']
        types.forEach(type => addStyleResource(config.module.rule('stylus').oneOf(type)))
    },
}

function addStyleResource (rule) {
    rule.use('style-resource')
        .loader('style-resources-loader')
        .options({
        patterns: [
                path.resolve(__dirname, './src/styles/imports.styl'),
            ],
        })
}