# Notes:
#  Copyright 2016 Hewlett-Packard Development Company, L.P.
#
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and associated documentation files (the "Software"),
#  to deal in the Software without restriction, including without limitation
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,
#  and/or sell copie of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.

module.exports = (robot) ->
  #check if hubot-enterprise is loaded
  if not robot.e
    robot.logger.error 'hubot-enterprise not present, kuku cannot run'
    return
  robot.logger.info 'kuku initialized'

  # register integration
  robot.e.registerIntegration {name: 'kuku',
  short_desc: 'what this integration does',
  long_desc: 'how this integration does it'}
  
  #register some functions
  robot.e.create {verb: 'create', entity: 'ticket',
  help: 'create ticket', type: 'respond'}, (msg)->
    robot.logger.debug  'in kuku create ticket'
    msg.reply 'in kuku create ticket'

  robot.e.create {verb: 'update', entity: 'ticket',
  help: 'update ticket', type: 'hear'}, (msg)->
    robot.logger.debug  'in kuku update ticket'
    msg.send 'in kuku update ticket'
