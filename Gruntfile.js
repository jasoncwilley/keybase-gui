'use strict';

var exec = require('child_process').exec;
var os   = require('os');
var path = require('path');

module.exports = function (grunt) {

    // Project configuration.
    grunt.initConfig({
        nodewebkit: {
            options: {
                build_dir: './webkitbuilds', // Where the build version of my node-webkit app is saved
                version: "0.8.5",
                mac: true, // We want to build it for mac
                win: true, // We want to build it for win
                linux32: false, // We don't need linux32
                linux64: false // We don't need linux64
            },
            src: ['./css/**', './fonts/**', './images/**', './js/**', './node_modules/**', '!./node_modules/grunt*/**', '!./node_modules/nodewebkit*/**', './index.html', './package.json', './README.md' ]
        }
    });

    // These plugins provide necessary tasks.
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-node-webkit-builder');

    grunt.registerTask('build', ['nodewebkit']);
    

};
