'use strict';

L = (things...) -> console.log.apply console, things

boxen = document.querySelectorAll 'form input[type="checkbox"]'
halptaxt = document.querySelector '.halptaxt'
filter_search = document.querySelector '#filter-search'

DISPLAY_AMOUNT = 5

search_string = null
results_collected = 0
sort_stack = []

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

    <br class='clear'/>
  """

# var debounce = null,
#     iframeEl = document.querySelectorAll('#vid iframe');
    
    
# if (iframeEl.length != 0) {
#   iframeEl = iframeEl[0];
  
#   console.log(iframeEl.getAttribute('width'))
#   console.log(iframeEl.getAttribute('height'))
  
#   iframeEl.setAttribute('data-aspect-ratio', iframeEl.getAttribute('width') / iframeEl.getAttribute('height'))
  
#   console.log(iframeEl.getAttribute('data-aspect-ratio'))
  
  
# }

# window.onresize = function(){
#   if (debounce != null)
#     clearTimeout(debounce);
    
#   debounce = setTimeout(function(){
#     var ifEl = document.querySelectorAll('#vid iframe');
#     if (iframeEl.length != 0) {
#       ifEl = ifEl[0];
#       ifEl.setAttribute('width', document.body.clientWidth)
#       ifEl.setAttribute('height', document.body.clientWidth / ifEl.getAttribute('data-aspect-ratio'))
#     }
#   }, 500);
# };

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

d3.json 'averaged.json', (err, json_data) ->
  if err
    console.error err
    throw new Error 'Error getting averaged'

  window.json = json_data
  Vs = json_data.Vehicles
  Cs = json_data.Characters
  Ws = json_data.Wheels

  PADDING = 50
  RANGE   = [ PADDING,     600-PADDING ]

  xScale = d3.scale.linear()
    .domain     [ 0, 6 ]
    .rangeRound RANGE
    .clamp true

  yScale = d3.scale.linear()
    # .domain     [ 0, Object.keys(Cs).length-1 ]
    .domain     [ 6, 0 ]
    .rangeRound RANGE
    .clamp true

  graph = d3.select '#graph'


  xAxis = d3.svg.axis()
    .scale xScale
    .orient 'bottom'
    .tickSize RANGE[1]-PADDING/2
    .tickFormat d3.format '.0'
    .ticks 7

  yAxis = d3.svg.axis()
    .scale yScale
    .orient 'left'
    .tickSize RANGE[1]-PADDING/2
    .tickFormat d3.format '.0'
    .ticks 7

  graph.append 'g'
    .attr 'id', 'xAxis'
    .attr 'transform', "translate(0,#{PADDING-20})"
    .call xAxis

  graph.append 'g'
    .attr 'id', 'yAxis'
    .attr 'transform', "translate(#{RANGE[1]+20},0)"
    .call yAxis

  character_points = graph.selectAll 'circle'
    .data d3.entries Cs
    .enter()
    .append 'circle'
    .attr 'cx', 0
    .attr 'cy', (d,i) -> yScale i
    .attr 'r', 3

  d3.selectAll('form input[type="checkbox"]').on 'click.graph', (c) ->
    if @checked
      sort_stack.push @name 
    else
      for stat, idx in sort_stack when stat is @name
        sort_stack.splice idx, 1

    character_points.transition()
      .attr 'cx', (d, i, el) -> 
        if 0 < sort_stack.length then xScale d.value[sort_stack[0]] else 0
      .attr 'cy', (d, i, el) ->
        if 1 < sort_stack.length then yScale d.value[sort_stack[1]] else yScale i
      .attr 'r',  (d, i, el) -> 3
      .attr 'stroke-width', '5px'



# d3.json 'combined.json', (err, json_data) -> 
#   if err
#     throw new Error 'Error getting data'

#   rows = d3.select('#listing')
#     .selectAll('div')
#     .data(d3.entries json_data)
#     .enter()
#     .append('div')
#     .html TEMPLATIZE

#   rows
#     .classed('row', true)
#     # TODO: change this to a delegate
#     .each (d, i) ->
#       @addEventListener 'click', (e) ->
#         if 'true' == @dataset.toggle
#           @dataset.toggle = 'false'
#           @querySelector('.details').classList.add 'hide'
#         else
#           @dataset.toggle = 'true'
#           @querySelector('.details').classList.remove 'hide'
      
#       @classList.add 'hide'

#   FILTER_RESULTS = (d, i) ->
#     if search_string is null
#       i > DISPLAY_AMOUNT
#     else
#       if search_string.test "".concat.apply [].concat.apply [], d.value.Options
#         results_collected++ > DISPLAY_AMOUNT
#       else
#         true

#   d3.select('#filter-search').on 'input', ->
#     if filter_search.value.length < 2
#       return search_string = null

#     search_string = new RegExp filter_search.value, 'i'
#     rows.classed 'hide', FILTER_RESULTS
#     results_collected = 0

#   d3.selectAll('form input[type="checkbox"]').on 'click.sort', (c) ->

#     L 'butts'

#     sorting_by = []

#     for b in boxen when b.checked is true
#       sorting_by.push @name

#     return if sorting_by.length == 0

#     rows
#     .sort (a, b) ->
#       score(b.value, sorting_by) - score(a.value, sorting_by)
#     .classed 'hide', FILTER_RESULTS
#     results_collected = 0
