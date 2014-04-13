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
                mac: true, // We want to build it for mac
                win: true, // We want to build it for win
                linux32: false, // We don't need linux32
                linux64: false // We don't need linux64
            },
            src: ['./css/**', './fonts/**', './images/**', './js/**', './node_modules/**', '!./node_modules/grunt*/**', './index.html', './package.json', './README.md' ]
        }
    });

    // These plugins provide necessary tasks.
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-node-webkit-builder');

    // Default task.
    grunt.registerTask('default', ['run']);
    grunt.registerTask('run', ['nodewebkit', 'start-nw']);
    
    grunt.registerTask('start-nw', function () {
        var filePath = grunt.config.get('nodewebkit').options.build_dir;
        filePath = path.join(filePath, "releases", "keybase-gui");

        if (os.platform() === 'win32') {
            var executable = path.join(".", filePath, "win", "keybase-gui", "keybase-gui.exe");
            console.log(executable);
            grunt.util.spawn({ cmd: executable }, function (error, res, code) {
                if(err) throw err;
                console.log("42");
            });   
        } else if (os.platform() === 'osx') {
            var executable = path.join(filePath, "mac", "keybase-gui.app");
            grunt.util.spawn("open " + executable, function(error, res, code) {
            }); 
        } else if (os.platform() === 'linux') {
            console.log("Would you kindly implement linux support?");
        }
    });
    

};
