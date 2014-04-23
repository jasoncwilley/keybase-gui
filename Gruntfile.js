'use strict';

module.exports = function (grunt) {
  // Project configuration.
  grunt.initConfig({
    coffeelint: {
      app: ['coffee/**/*.iced']
    },
    coffee: {
      compile: {
        options: {
          sourceMap: true
        },
        files: {
          'build/js/app.js': ['coffee/KeybaseGuiApp.iced',
                              'coffee/**/*.iced']
        }
      }
    },
    sass: {
      dist: {
        options: {
          style: 'expanded'
        },
        files: {
          'build/css/app.css': 'build/sass/app.scss'
        }
      }
    },
    concat: {
      options: {
        separator: ';',
      },
      jsLibs: {
        src: ['bower_components/jquery/dist/jquery.js',
              'bower_components/angular/angular.js',
              'bower_components/angular-animate/angular-animate.js',
              'bower_components/bootstrap/dist/js/bootstrap.js',
              'bower_components/angular-cookies/angular-cookies.js',
              'bower_components/angularLocalStorage/src/angularLocalStorage.js',
              'bower_components/angular-strap/dist/angular-strap.js',
              'bower_components/angular-strap/dist/angular-strap.tpl.js',
              'bower_components/angular-bootstrap/ui-bootstrap.js',
              'bower_components/angular-bootstrap/ui-bootstrap-tpls.js'],
        dest: 'build/js/libs.js',
      },
      cssLibs: {
        src: ['bower_components/bootstrap/dist/css/bootstrap.css',
              'bower_components/bootstrap/dist/css/bootstrap-theme.css',
              'bower_components/animate.css/animate.css'],
        dest: 'build/css/bootstrap.css'
      },
      sassStyles: {
        src: ['sass/**/*.scss'],
        dest: 'build/sass/app.scss'
      }
    },
    copy: {
      bootstrapFonts: {
        expand: true,
        cwd: 'bower_components/bootstrap/dist/fonts/',
        src: '*',
        dest: 'build/fonts/',
        flatten: true,
        filter: 'isFile'
      },
      images: {
        src: 'images/*',
        dest: 'build/images'
      }
    },
    clean: {
      build: ['build/'],
      release: ['webkitbuilds/releases']
    },
    uglify : {
      libs: {
        files: {
          './build/js/libs.js': ['./build/js/libs.js']
        }
      },
      app: {
        files: {
          './build/js/app.js': ['./build/js/app.js']
        }
      }
    },
    watch: {
      jsApp: {
        files: ['coffee/**/*.iced'],
        tasks: ['build-js-app']
      },
      css: {
        files: ['sass/**/*.scss'],
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
      src: ['build/**', './node_modules/**', '!./node_modules/grunt*/**',
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
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  
  grunt.registerTask('dev', ['build-dev', 'watch']);

  grunt.registerTask('build-js-libs', ['concat:jsLibs']);
  grunt.registerTask('build-js-app', ['coffeelint', 'coffee']);
  grunt.registerTask('build-js-dev', ['build-js-libs', 'build-js-app']);
  grunt.registerTask('build-js', ['build-js-dev', 'uglify']);
  grunt.registerTask('build-css', ['concat:sassStyles', 'sass', 'build-css-libs']);
  grunt.registerTask('build-css-libs', ['concat:cssLibs']);
  grunt.registerTask('build-fonts', ['copy:bootstrapFonts']);
  grunt.registerTask('build-images', ['copy:images']);
  grunt.registerTask('build-dev', ['build-js-dev', 'build-css', 'build-fonts', 'build-images']);
  grunt.registerTask('build', ['build-js', 'build-css', 'build-fonts', 'build-images']);

  grunt.registerTask('release', ['clean', 'build', 'nodewebkit']);
};
