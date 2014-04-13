module.exports = (grunt) ->

  grunt.initConfig
    pkg : grunt.file.readJSON('package.json')
    uglify :
      options :
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
    
      build : 
        src : 'src/<%= pkg.name %>.js',
        dest: 'build/<%= pkg.name %>.min.js'

    coffee: 
      build:
        expand: true,
        cwd: './src',
        src: ['**/*.coffee'],
        dest: './',
        ext: '.js'
        extDot : 'last'

    mochaTest:
      test:
        options:
          reporter: 'spec'
        src: ['test/**/*.js']

    shell:
      peg:
        command: "pegjs pfgdl_syntax.pegjs ast/gdl_parser.js"


  #grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-mocha-test')
  grunt.loadNpmTasks('grunt-shell')

  grunt.registerTask('default', ['shell:peg','coffee','mochaTest'])



