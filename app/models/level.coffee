NB.Level = class Level
  waveLifespan: 1200

  constructor: (data) ->
    @waves = for waveData in data.wavesData
      waveData.path = data.map.path
      new NB.Wave(waveData)
    @currentWaves = []
    @map = data.map
    @tree = data.tree
    @money = 1000
    @currentWaveIndex = 0
    @currentWaveAge = 0
  sendWave: (index) ->
    while @currentWaveIndex < index
      @sendNextWave()
  sendNextWave: ->
    @started = true
    if @waves.isEmpty()
      false
    else
      @currentWaves.push(@waves.shift())
      @currentWaveIndex++
      @currentWaveAge = 0
      true
  tick: ->
    if @started
      @currentWaveAge++
      if (@currentWaveAge > @waveLifespan) && !@waves.isEmpty()
        @sendNextWave()
    wave.tick() for wave in @currentWaves
    @map.tick()
  findCreep: (criteria) ->
    (wave.findCreep(criteria) for wave in @currentWaves)
  placeTower: (tower, coordinates) ->
    @map.placeTower(tower, coordinates)
    @chargeMoney(tower.cost)
  canPlaceTower: (tower, coordinates) ->
    @map.canPlaceTower(tower, coordinates)
  checkForVictory: ->
    return false if @waves.length > 0
    for wave in @currentWaves
      return false if wave.isAlive()
    true
  notifyCompletionOf: (completedWave) ->
    @currentWaves.remove(completedWave)
    if @currentWaves.isEmpty() && @waves.isEmpty()
      NB.Director.endGame(true)
  removeTower: (tower) ->
    @map.removeTower(tower)
  chargeMoney: (dollars) ->
    @money -= dollars
  canAfford: (dollars) ->
    @money >= dollars
