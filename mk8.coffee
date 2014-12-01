'use strict';

L = (things...) -> console.log.apply console, things

boxen = document.querySelectorAll 'form input'
halptaxt = document.querySelector '.halptaxt'
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
        <div class='bar sub-bar speed-bar'    style='width: #{(d.value["Speed"]["Ground"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar sub-bar speed-bar'    style='width: #{(d.value["Speed"]["Water"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar sub-bar speed-bar'    style='width: #{(d.value["Speed"]["Air"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar sub-bar speed-bar'    style='width: #{(d.value["Speed"]["Anti-Gravity"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar acceleration-bar'     style='width: #{(d.value["Acceleration"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar weight-bar'           style='width: #{(d.value["Weight"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar sub-bar handling-bar' style='width: #{(d.value["Handling"]["Ground"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar sub-bar handling-bar' style='width: #{(d.value["Handling"]["Water"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar sub-bar handling-bar' style='width: #{(d.value["Handling"]["Air"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar sub-bar handling-bar' style='width: #{(d.value["Handling"]["Anti-Gravity"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar traction-bar'         style='width: #{(d.value["Traction"]) / 6 * 100 + '%'}'>&nbsp;</div>
        <div class='bar miniturbo-bar'        style='width: #{(d.value["Mini-Turbo"]) / 6 * 100 + '%'}'>&nbsp;</div>
      </div>
    </div>
    <div class='details hide'>
      <hr/>
      <div class='optnames'>
        <div class='opt charopts'><p>#{d.value.Options[0].join "</p><p>"}</p></div>
        <div class='opt vehicleopts'><p>#{d.value.Options[1].join "</p><p>"}</p></div>
        <div class='opt wheelsopts'><p>#{d.value.Options[2].join "</p><p>"}</p></div>
        <hr/>
      </div>
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
          <td>#{d.value["Speed"]["Ground"]}</td>
          <td>#{d.value["Speed"]["Water"]}</td>
          <td>#{d.value["Speed"]["Air"]}</td>
          <td>#{d.value["Speed"]["Anti-Gravity"]}</td>
          <td>#{d.value["Acceleration"]}</td>
          <td>#{d.value["Weight"]}</td>
          <td>#{d.value["Handling"]["Ground"]}</td>
          <td>#{d.value["Handling"]["Water"]}</td>
          <td>#{d.value["Handling"]["Air"]}</td>
          <td>#{d.value["Handling"]["Anti-Gravity"]}</td>
          <td>#{d.value["Traction"]}</td>
          <td>#{d.value["Mini-Turbo"]}</td>
          </tr>
        </tbody>
      </table>
    </div>

    <br style='clear:both';/>
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

score = (combo, keys) ->
  return 0 unless keys.length isnt 0
  vals = []
  sum = 0

  for k in keys
    if k == "Handling" or k == "Speed"

      if combo[k]["avg"] is undefined
        combo[k]["avg"] = (combo[k]["Ground"] + combo[k]["Air"] + combo[k]["Water"] + combo[k]["Anti-Gravity"] ) / 4
        
      sum += combo[k]["avg"]
      vals.push combo[k]["avg"]
    
    else if k == "Acceleration"
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

d3.json 'combined.json', (err, json_data) -> 
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
      switch b.name
        when 's' then sorting_by.push "Speed"
        when 'a' then sorting_by.push "Acceleration"
        when 'w' then sorting_by.push "Weight"
        when 'h' then sorting_by.push "Handling"
        when 't' then sorting_by.push "Traction"
        when 'm' then sorting_by.push "Mini-Turbo"

    return if sorting_by.length == 0

    rows
    .sort (a, b) ->
      score(b.value, sorting_by) - score(a.value, sorting_by)
    .classed 'hide', FILTER_RESULTS
    results_collected = 0
