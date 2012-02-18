NB.Tower::drawRange = (ctx) ->
  dim = 32
  if @range && @shouldDrawRange
    for cell in @range
      ctx.fillStyle = "rgba(255,255,255,.3)"
      ctx.fillRect((cell[0] * dim), (cell[1] * dim), dim, dim)

NB.Tower::drawUpgrades = ->
  #FIXME Refactor!!!!!
  tower = this

  $power = $('#upgrades .power')
  if @canUpgradePower
    $power.find('.can_upgrade').show()
    $power.find('.cannot_upgrade').hide()
    $power.find('.orig').text(@power)

    nextUpgrade = @nextPowerUpgrade()
    if nextUpgrade == null # maxed out
      $power.find('.not_maxed').hide()
    else
      powerCost = nextUpgrade.cost
      dmg = nextUpgrade.dmg
      $power.find('.not_maxed').show()
      $power.find('.new').text(dmg)
      $power.find('.cost').text(powerCost)
      $power.off('click', '.button')
      $power.on('click', '.button', (e) ->
        if NB.Director.level.canAfford(powerCost)
          NB.Director.level.chargeMoney(powerCost)
          tower.upgradePower()
          tower.drawUpgrades()
      )
  else
    $power.find('.can_upgrade').hide()
    $power.find('.cannot_upgrade').show()

  $speed = $('#upgrades .speed')
  if @canUpgradeSpeed
    $speed.find('.can_upgrade').show()
    $speed.find('.cannot_upgrade').hide()
    $speed.find('.orig').text(@speed)

    nextUpgrade = @nextSpeedUpgrade()
    if nextUpgrade == null # maxed out
      $speed.find('.not_maxed').hide()
    else
      speedCost = nextUpgrade.cost
      rate = nextUpgrade.rate
      $speed.find('.not_maxed').show()
      $speed.find('.new').text(rate)
      $speed.find('.cost').text(speedCost)
      $speed.off('click', '.button')
      $speed.on('click', '.button', (e) ->
        if NB.Director.level.canAfford(speedCost)
          NB.Director.level.chargeMoney(speedCost)
          tower.upgradeSpeed()
          tower.drawUpgrades()
      )
  else
    $speed.find('.can_upgrade').hide()
    $speed.find('.cannot_upgrade').show()


  $range = $('#upgrades .range')
  if @canUpgradeRange
    $range.find('.can_upgrade').show()
    $range.find('.cannot_upgrade').hide()
    $range.find('.orig').text(@radius)

    nextUpgrade = @nextRangeUpgrade()
    if nextUpgrade == null # maxed out
      $range.find('.not_maxed').hide()
    else
      cost = nextUpgrade.cost
      $range.find('.not_maxed').show()
      $range.find('.new').text(nextUpgrade.sq)
      $range.find('.cost').text(cost)
      $range.off('click', '.button')
      $range.on('click', '.button', (e) ->
        if NB.Director.level.canAfford(cost)
          NB.Director.level.chargeMoney(cost)
          tower.upgradeRange()
          tower.drawUpgrades()
      )
  else
    $range.find('.can_upgrade').hide()
    $range.find('.cannot_upgrade').show()

  # TODO check if you even can prioritize (i.e. sumo can't)
  $priority = $('#upgrades .priority')
  $priority.off('click', '.button')
  $priority.on('click', '.button', (e) ->
    switch(e.toElement.dataset.priority)
      when 'first'     then priority = NB.Priorities.FIRST
      when 'last'      then priority = NB.Priorities.LAST
      when 'weakest'   then priority = NB.Priorities.WEAKEST
      when 'strongest' then priority = NB.Priorities.STRONGEST
    tower.priority = priority if priority
    tower.drawUpgrades()
  )
  priority = tower.priority.name
  $priority.find("a").removeClass('highlight')
  $priority.find("a[data-priority=#{priority}]").addClass('highlight')

  $('#upgrades').show()

NB.Tower::undrawUpgrades = ->
  $('#upgrades').hide()