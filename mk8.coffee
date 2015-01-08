'use strict';

L = (things...) -> console.log.apply console, things

L document.querySelector '.cheating'

boxen = document.querySelectorAll 'form input'
halptaxt = document.querySelector '.halptaxt'
CSScheat = document.querySelector '.cheating'

CSS_bar_toggle = 
  enable: '.speed-bar.sub-bar,.handling-bar.sub-bar { display: block !important } .speed-bar.bar,.handling-bar.bar { display: none !important }'
  disable: '.speed-bar.sub-bar,.handling-bar.sub-bar { display: none !important } .speed-bar.bar,.handling-bar.bar { display: block !important }'
filter_search = document.querySelector '#filter-search'

DISPLAY_AMOUNT = 5

search_string = null
results_collected = 0

TEMPLATIZE =  (d, i) ->
  char_images = []
  vehicle_images = []
  tire_images = []
  space_regex = `/ /g` #because mutiple-replacement only works with regexs

  for c in d.value.Options[0]
    char_images.push "<div title='#{c}' alt='#{c}' class='charopt mk8#{c.replace(space_regex, '').replace('.','').toLowerCase()}'></div>"
  for v in d.value.Options[1]
    vehicle_images.push "<div title='#{v}' alt='#{v}' class='bodyopt mk8#{v.replace(space_regex, '').replace('.','').toLowerCase()}body'></div>"
  for t in d.value.Options[2]
    tire_images.push "<div title='#{t}' alt='#{t}' class='tireopt mk8#{t.replace(space_regex, '').replace('.','').toLowerCase()}tires'></div>"

  """
    <div class='combo-details'>
      <div class='opts'>
        <div class='opt charopts'>#{char_images.join ""}</div>
        <div class='opt vehicleopts'>#{vehicle_images.join ""}</div>
        <div class='opt wheelsopts'>#{tire_images.join ""}</div>
      </div>
      <div class='chart'>
        <div class='bar bar speed-bar'        style='width: #{(d.value["Speed"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='sub-bar speed-bar'        style='width: #{(d.value["SpeedByTerrain"]["Ground"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='sub-bar speed-bar'        style='width: #{(d.value["SpeedByTerrain"]["Water"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='sub-bar speed-bar'        style='width: #{(d.value["SpeedByTerrain"]["Air"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='sub-bar speed-bar'        style='width: #{(d.value["SpeedByTerrain"]["Anti-Gravity"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar acceleration-bar'     style='width: #{(d.value["Acceleration"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar weight-bar'           style='width: #{(d.value["Weight"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar handling-bar'         style='width: #{(d.value["Handling"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='sub-bar handling-bar'     style='width: #{(d.value["HandlingByTerrain"]["Ground"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='sub-bar handling-bar'     style='width: #{(d.value["HandlingByTerrain"]["Water"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='sub-bar handling-bar'     style='width: #{(d.value["HandlingByTerrain"]["Air"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='sub-bar handling-bar'     style='width: #{(d.value["HandlingByTerrain"]["Anti-Gravity"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar traction-bar'         style='width: #{(d.value["Traction"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar miniturbo-bar'        style='width: #{(d.value["Mini-Turbo"]) / 6 * 100 + '%'}'>&nbsp;</div>
      </div>
      <br class='clear'/>
    </div>
    <div class='details hide'>
      <hr class='clear'/>
      <div class='optnames'>
        <div class='opt charopts'><p>#{d.value.Options[0].join "</p><p>"}</p></div>
        <div class='opt vehicleopts'><p>#{d.value.Options[1].join "</p><p>"}</p></div>
        <div class='opt wheelsopts'><p>#{d.value.Options[2].join "</p><p>"}</p></div>
        <div class='clear'/>
      </div>
      <hr class='clear'/>
      <table class='stat'>
        <thead>
          <tr>
              <th colspan='4'>Speed</th>
              <th>Acceleration</th>
              <th>Weight</th>
              <th colspan='4'>Handling</th>
              <th>Traction</th>
              <th>Mini-Turbo</th>
          </tr>
          <tr>
              <th class='speed-heading'>Ground</th>
              <th class='speed-heading'>Water</th>
              <th class='speed-heading'>Air</th>
              <th class='speed-heading'>Anti-Gravity</th>
              <th class='acceleration-heading'></th>
              <th class='weight-heading'></th>
              <th class='handling-heading'>Ground</th>
              <th class='handling-heading'>Water</th>
              <th class='handling-heading'>Air</th>
              <th class='handling-heading'>Anti-Gravity</th>
              <th class='traction-heading'></th>
              <th class='miniturbo-heading'></th>
          </tr>
        </thead>
        <tbody>
          <tr>
          <td>#{d.value["SpeedByTerrain"]["Ground"]}</td>
          <td>#{d.value["SpeedByTerrain"]["Water"]}</td>
          <td>#{d.value["SpeedByTerrain"]["Air"]}</td>
          <td>#{d.value["SpeedByTerrain"]["Anti-Gravity"]}</td>
          <td>#{d.value["Acceleration"]}</td>
          <td>#{d.value["Weight"]}</td>
          <td>#{d.value["HandlingByTerrain"]["Ground"]}</td>
          <td>#{d.value["HandlingByTerrain"]["Water"]}</td>
          <td>#{d.value["HandlingByTerrain"]["Air"]}</td>
          <td>#{d.value["HandlingByTerrain"]["Anti-Gravity"]}</td>
          <td>#{d.value["Traction"]}</td>
          <td>#{d.value["Mini-Turbo"]}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <br class='clear'/>
  """

# unique IDs automatically become properties of the window object, T.I.L.!

document.querySelector '.halp'
  .addEventListener 'click', (e) ->
    if @dataset.toggle == 'true'
      @dataset.toggle = 'false'
      halptaxt.classList.add 'hide'
    else
      @dataset.toggle = 'true'
      halptaxt.classList.remove 'hide'

document.querySelector '.terrain-stats'
  .addEventListener 'click', (e) ->
    if @dataset.toggle == 'true'
      @dataset.toggle = 'false'
      CSScheat.innerHTML = CSS_bar_toggle.disable
    else
      @dataset.toggle = 'true'
      CSScheat.innerHTML = CSS_bar_toggle.enable


score = (combo, keys) ->
  return 0 unless keys.length isnt 0
  vals = []
  sum = 0

  for k in keys
    # if k == "Handling" or k == "Speed"

    #   # if combo[k]["avg"] is undefined
    #   #   combo[k]["avg"] = (combo[k]["Ground"] + combo[k]["Air"] + combo[k]["Water"] + combo[k]["Anti-Gravity"] ) / 4
        
    #   sum += combo[k]["avg"]
    #   vals.push combo[k]["avg"]
    
    if k == "Acceleration"
      sum += Math.floor combo[k]
      vals.push Math.floor combo[k]
    else
      sum += combo[k]
      vals.push combo[k]

  return sum unless keys.length > 1

  avg_of_vals = (vals.reduce (a, b) -> a + b) / keys.length

  calculate_deviations = (a, b) -> a + (b - avg_of_vals) ** 2

  deviation = vals.reduce calculate_deviations, 0

  (sum ** 2) / (1 + deviation ** 2)

d3.json 'averaged_and_combined.json', (err, json_data) -> 
  if err
    throw new Error 'Error getting data'

  rows = d3.select('#listing')
    .selectAll('div')
    .data(d3.entries json_data)
    .enter()
    .append('div')
    .html TEMPLATIZE

  rows
    .classed('row', true)
    # TODO: change this to a delegate
    .each (d, i) ->
      @addEventListener 'click', (e) ->
        if 'true' == @dataset.toggle
          @dataset.toggle = 'false'
          @querySelector('.details').classList.add 'hide'
        else
          @dataset.toggle = 'true'
          @querySelector('.details').classList.remove 'hide'
      
      @classList.add 'hide'

  FILTER_RESULTS = (d, i) ->
    if search_string is null
      i > DISPLAY_AMOUNT
    else
      if search_string.test "".concat.apply [].concat.apply [], d.value.Options
        results_collected++ > DISPLAY_AMOUNT
      else
        true

    

  d3.select('#filter-search').on 'input', ->
    if filter_search.value.length < 2
      return search_string = null

    search_string = new RegExp filter_search.value, 'i'
    rows.classed 'hide', FILTER_RESULTS
    results_collected = 0

  d3.selectAll('form input[type="checkbox"]').on 'click', (c) ->

    sorting_by = []

    for b in boxen when b.checked is true
      sorting_by.push b.name

    return if sorting_by.length == 0

    rows
    .sort (a, b) ->
      score(b.value, sorting_by) - score(a.value, sorting_by)
    .classed 'hide', FILTER_RESULTS
    results_collected = 0
