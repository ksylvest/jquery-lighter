{spawn, exec} = require 'child_process'

command = (name, args...) ->
  proc = spawn name, args
  
  proc.stderr.on 'data', (buffer) -> 
    console.log(buffer.toString())
    growl.notify(message) if growl?
    
  proc.stdout.on 'data', (buffer) -> 
    console.log buffer.toString()
    growl.notify(message) if growl?
  
  proc.on 'exit', (status) -> process.exit(1) if status != 0

task 'watch', 'SASS and CoffeeScript asset watching', (options) ->
  command 'sass', '--watch', 'stylesheets:stylesheets', '-r', './bourbon/lib/bourbon.rb'
  command 'coffee', '-wc', 'javascripts'

task 'compile', 'HAML sample compilation', (opions) ->
  command 'haml', 'sample.haml', 'sample.html'

notify = (title = '', message = '') -> 
  options = title: title
  growl.notify message, options