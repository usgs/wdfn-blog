const autoprefixerBrowsers = [
    '> 1%',
    'Last 2 versions',
    'IE 11'
];

module.exports = ctx => ({
    map: Object.assign({}, ctx.options.map, {inline: false}),
    parser: ctx.options.parser,
    plugins: {
        autoprefixer: autoprefixerBrowsers,
        cssnano: {
            autoprefixer: {
                browsers: autoprefixerBrowsers
            }
        },
        'css-mqpacker': {
            sort: false
        },
        'postcss-flexbugs-fixes': {}
    }
});
