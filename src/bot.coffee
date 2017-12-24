# Description:
#   Hubot integration with Atlassian Stash.
#
# Configuration:
#  HUBOT_STASH_USERNAME
#  HUBOT_STASH_PASSWORD
#
# Commands:
#   hubot stash - Lists the subscriptions in the current room
#   hubot stash add <api url> - Subscribe current room to PR changes on the given API url, e.g. http://stash.saas.hpeswlab.net:7990/rest/api/1.0/projects/saas/repos/portal-integration/pull-requests
#   hubot stash rm <api url> - Unsubscribe current room from PR changes on the given API url, e.g. http://stash.saas.hpeswlab.net:7990/rest/api/1.0/projects/saas/repos/portal-integration/pull-requests
#   hubot stash ping <name> <api url> - Pings the given name when a PR is opened on the given API url
#   hubot stash unping <name> <api url> - Remove pings for the given name when PR opens on the given API url


Broker = require '../utils/broker'
Poller = require '../utils/poller'
config = require '../config/config'
format = require '../utils/format'

commands =
  rm: require '../commands/rm'
  add: require '../commands/add'
  list: require '../commands/list'
  ping: require '../commands/ping'
  unping: require '../commands/unping'


# will be instantiated when bot is activated
utils =
  poller: undefined
  broker: undefined


bot = (robot) ->
  utils.poller = new Poller robot: robot
  utils.broker = new Broker robot: robot


  # =========================================================================
  #  RESPONSES
  # =========================================================================
  robot.respond /stash$/i, (msg) ->
    commands.list
      msg: msg
      broker: utils.broker


  robot.respond /stash add (.*)/i, (msg) ->
    commands.add
      msg: msg
      broker: utils.broker

  robot.respond /stash rm (.*)/i, (msg) ->
    commands.rm
      msg: msg
      broker: utils.broker

  robot.respond /stash ping ([^\s]+) (.*)/i, (msg) ->
    commands.ping
      msg: msg
      broker: utils.broker


  robot.respond /stash unping ([^\s]+) (.*)/i, (msg) ->
    commands.unping
      msg: msg
      broker: utils.broker

  robot.respond /stash detail ([^\s]+) (\d+)/i, (msg) ->
    commands.detail
      msg: msg
      broker: utils.broker

  # =========================================================================
  #  POLLING
  # =========================================================================
  sendRoomMessages = (forApiUrl, message) ->
    repo = robot.brain.data['stash-poll']?[forApiUrl]
    return if not repo? or not repo.rooms?

    for roomHandle in repo.rooms
      robot.messageRoom(roomHandle, message)


  utils.poller.events.on 'pr:open', (prData) ->
    sendRoomMessages prData.api_url, format.pr.opened(prData)


  utils.poller.events.on 'pr:merge', (prData) ->
    sendRoomMessages prData.api_url, format.pr.merged(prData)


  utils.poller.events.on 'pr:decline', (prData) ->
    sendRoomMessages prData.api_url, format.pr.declined(prData)


  utils.poller.events.on 'repo:failed', (repo) ->
    sendRoomMessages repo.api_url, format.repo.failed(repo)


  utils.poller.start()


module.exports = bot