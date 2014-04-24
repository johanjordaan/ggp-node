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
          reporter: 'dot'
        src: ['test/**/*.js']

    shell:
      jison_generate:
        command: "jison grammar.jison -o grammar/grammar_parser.js"

    nodemon:
      dev:
        script: 'player/player_server.js'

  #grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-mocha-test')
  grunt.loadNpmTasks('grunt-shell')
  grunt.loadNpmTasks('grunt-nodemon')

  grunt.registerTask('default', ['shell:jison_generate','coffee','mochaTest'])
  grunt.registerTask('run', ['shell:jison_generate','coffee','mochaTest','nodemon'])




