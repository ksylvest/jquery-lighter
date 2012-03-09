{spawn, exec} = require 'child_process'

task 'assets:watch', 'SASS and CoffeeScript asset compilation', (options) ->
  command = (name, args) ->
    proc = spawn name, args
    proc.stderr.on   'data', (buffer) -> console.log buffer.toString()
    proc.stdout.on   'data', (buffer) -> console.log buffer.toString()
    proc.on          'exit', (status) -> process.exit(1) if status != 0
    
  command 'sass', ['--watch', 'stylesheets:stylesheets', '-r', './bourbon/lib/bourbon.rb']