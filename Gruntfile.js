'use strict';

module.exports = function (grunt) {
  // Project configuration.
  grunt.initConfig({
    coffee: {
      compile: {
        files: {
          'build/js/app.js': 'coffee/**/*.iced'
        }
      }
    },
    concat: {
      options: {
        separator: ';',
      },
      libs: {
        src: ['bower_components/angular/angular.js'],
        dest: 'build/js/libs.js',
      }
    },
    copy: {
      js: {
        expand: true,
        cwd: 'build/js',
        src: '*.js',
        dest: 'build/app/js/',
        flatten: true,
        filter: 'isFile'
      },
      css: {
        src: 'build/css/*',
        des: 'build/app/css/',
        flatten: true
      },
      fonts: {
        src: 'fonts/*',
        dest: 'build/app/fonts/'
      },
      images: {
        src: 'images/*',
        dest: 'build/app/images'
      }
    },
    clean: {
      build: ['build/'],
      release: ['webkitbuilds/releases']
    },
    watch: {
      jsApp: {
        files: ['coffee/**/*.iced'],
        tasks: ['build-js-app']
      },
      css: {
        files: ['css/**/*.css'],
        tasks: ['build-css']
      }
    },
    nodewebkit: {
      options: {
        build_dir: './webkitbuilds',
        version: "0.8.5",
        mac: true, // We want to build it for mac
        win: true, // We want to build it for win
        linux32: false, // We don't need linux32
        linux64: false // We don't need linux64
      },
      src: ['build/app/**', './node_modules/**', '!./node_modules/grunt*/**',
             '!./node_modules/nodewebkit*/**', './index.html', './package.json',
             './README.md' ]
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-node-webkit-builder');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-iced-coffee');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-clean');

  grunt.registerTask('dev', ['build', 'watch']);

  grunt.registerTask('build-js-libs', ['concat:libs']);
  grunt.registerTask('build-js-app', ['coffee']);
  grunt.registerTask('build-js', ['build-js-libs', 'build-js-app', 'copy:js']);
  grunt.registerTask('build-css', ['copy:css']);
  grunt.registerTask('build-fonts', ['copy:fonts']);
  grunt.registerTask('build-images', ['copy:images']);
  grunt.registerTask('build', ['build-js', 'build-css', 'build-fonts', 'build-images']);

  grunt.registerTask('release', ['clean', 'build', 'nodewebkit']);
};
