'use strict';

module.exports = function (grunt) {

  var buildNumber = process.env.TRAVIS_BUILD_NUMBER || -1;
  var distFiles = ['build/**', './node_modules/**', '!./node_modules/grunt*/**',
             '!./node_modules/nodewebkit*/**',
             './index.html', './package.json',
             './README.md' ];
  var debug = !process.env.CI;

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
          style: 'expanded',
	  loadPath: ['bower_components/bootstrap-sass-official/vendor/assets/stylesheets']
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
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/alert.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/button.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/carousel.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/collapse.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/dropdown.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/tab.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/transition.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/scrollspy.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/modal.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/tooltip.js',
              'bower_components/bootstrap-sass-official/vendor/assets/javascripts/bootstrap/popover.js',
              'bower_components/angular/angular.js',
              'bower_components/angular-animate/angular-animate.js',
              'bower_components/angular-sanitize/angular-sanitize.js',
              'bower_components/angular-cookies/angular-cookies.js',
              'bower_components/angularLocalStorage/src/angularLocalStorage.js',
              'bower_components/angular-strap/dist/angular-strap.js',
              'bower_components/angular-strap/dist/angular-strap.tpl.js',
              'bower_components/angular-bootstrap/ui-bootstrap.js',
              'bower_components/angular-bootstrap/ui-bootstrap-tpls.js'],
        dest: 'build/js/libs.js',
      },
      cssLibs: {
        src: ['bower_components/animate.css/animate.css'],
        dest: 'build/css/libs.css'
      },
      sassStyles: {
        src: ['sass/**/*.scss'],
        dest: 'build/sass/app.scss'
      }
    },
    copy: {
      bootstrapFonts: {
        expand: true,
        cwd: 'bower_components/bootstrap-sass-official/vendor/assets/fonts/bootstrap',
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
      },
      config: {
        './build/js/config.js': ['./build/js/config.js']
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
    ngconstant: {
      dist: {
        options: {
          name: 'keybase-gui.config',
          dest: 'build/js/config.js'
        },
        constants: {
          keybaseGuiConfig: {
            version: buildNumber,
            updateServer: 'https://jhbruhn.github.io/keybase-gui/',
            debug: debug
          }
        }
      }
    },
    nodewebkit: {
      options: {
        build_dir: './webkitbuilds',
        version: "0.8.5",
        mac: true, // We want to build it for mac
        win: true, // We want to build it for win
        linux32: true, // We do need linux32
        linux64: true, // We do need linux64
        keep_nw: true

      },
      src: distFiles
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
  grunt.loadNpmTasks('grunt-ng-constant');

  grunt.registerTask('dev', ['build-dev', 'watch']);

  grunt.registerTask('build-js-libs', ['concat:jsLibs']);
  grunt.registerTask('build-js-app', ['coffeelint', 'coffee']);
  grunt.registerTask('build-js-dev', ['build-js-libs', 'build-js-app', 'ngconstant']);
  grunt.registerTask('build-js', ['build-js-dev', 'uglify']);

  grunt.registerTask('build-css', ['concat:sassStyles', 'sass', 'build-css-libs']);
  grunt.registerTask('build-css-libs', ['concat:cssLibs']);

  grunt.registerTask('build-fonts', ['copy:bootstrapFonts']);

  grunt.registerTask('build-images', ['copy:images']);

  grunt.registerTask('build-dev', ['build-js-dev', 'build-css', 'build-fonts', 'build-images']);
  grunt.registerTask('build', ['build-js', 'build-css', 'build-fonts', 'build-images']);

  grunt.registerTask('release', ['clean', 'build', 'nodewebkit']);
};
