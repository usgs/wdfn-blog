/**
 * Rollup configuration.
 * NOTE: This is a CommonJS module so it can be imported by Karma.
 */
const path = require('path');

const buble = require('@rollup/plugin-buble');
const resolve = require('@rollup/plugin-node-resolve');
const {terser} = require('rollup-plugin-terser');


const ENV = process.env.NODE_ENV || 'development';

module.exports = {
    input: 'src/scripts/index.js',
    plugins: [
        resolve.nodeResolve({
            mainFields: ['module']
        }),
        buble({
            objectAssign: 'Object.assign',
            transforms: {
                dangerousForOf: true
            }
        }),
        ENV === 'production' && terser({
            compress: {
                drop_console: true
            }
        })
    ],
    output: {
        file: 'static/scripts/bundle.js',
        format: 'iife',
        sourcemap: ENV !== 'production' ? 'inline' : false
    },
    treeshake: ENV === 'production'
};
