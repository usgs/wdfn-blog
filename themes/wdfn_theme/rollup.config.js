/**
 * Rollup configuration.
 * NOTE: This is a CommonJS module so it can be imported by Karma.
 */
const path = require('path');

const alias = require('rollup-plugin-alias');
const buble = require('rollup-plugin-buble');
const commonjs = require('rollup-plugin-commonjs');
const resolve = require('rollup-plugin-node-resolve');
const { uglify } = require('rollup-plugin-uglify');


const ENV = process.env.NODE_ENV || 'development';

module.exports = {
    input: 'src/scripts/index.js',
    plugins: [
        alias({
            ngwmn: path.resolve(__dirname, 'src/scripts'),
            resolve: ['.js', '.json']
        }),
        resolve({
            // use "module" field for ES6 module if possible
            module: true, // Default: true

            // use "jsnext:main" if possible
            // – see https://github.com/rollup/rollup/wiki/jsnext:main
            jsnext: false,

            // use "main" field or index.js, even if it's not an ES6 module
            // (needs to be converted from CommonJS to ES6
            // – see https://github.com/rollup/rollup-plugin-commonjs
            main: false,  // Default: true

            // some package.json files have a `browser` field which
            // specifies alternative files to load for people bundling
            // for the browser. If that's you, use this option, otherwise
            // pkg.browser will be ignored
            browser: false  // Default: false
        }),
        commonjs(),
        buble({
            objectAssign: 'Object.assign',
            transforms: {
                dangerousForOf: true
            }
        }),
        ENV === 'production' && uglify({
            compress: {
                dead_code: true,
                drop_console: true
            }
        })
    ],
    output: {
        name: 'ngwmn_ui',
        file: 'static/scripts/bundle.js',
        format: 'iife',
        sourcemap: ENV !== 'production' ? 'inline' : false
    },
    treeshake: ENV === 'production'
};
