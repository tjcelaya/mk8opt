'use strict';

L = (things...) -> console.log.apply console, things

boxen = document.querySelectorAll 'form input[type="checkbox"]'
filter_search = document.querySelector '#filter-search'
space_regex = `/ /g` #because mutiple-replacement only works with regexs

DISPLAY_AMOUNT = 5
COLOR_TABLE = {
  "Speed":        d3.rgb(255, 0, 0),
  "Acceleration": d3.rgb(255, 214, 3),
  "Weight":       d3.rgb(42, 186, 71),
  "Handling":     d3.rgb(95, 158, 160),
  "Traction":     d3.rgb(46, 46, 249),
  "Mini-Turbo":   d3.rgb(255, 97, 0)
}
search_string = null
results_collected = 0
sort_stack = []

TEMPLATIZE =  (d, i) ->
  char_images = []
  vehicle_images = []
  tire_images = []

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

d3.json 'averaged_and_combined.json', (err, json_data) ->
  if err
    console.error err
    throw new Error 'Error getting averaged'

  PADDING = 50
  RANGE   = [ PADDING, 600-PADDING ]

  xScale = d3.scale.linear()
    .domain     [ 0, 6 ]
    .rangeRound RANGE
    .clamp true

  yScale = d3.scale.linear()
    # .domain     [ 0, Object.keys(Cs).length-1 ]
    .domain     [ 6, 0 ]
    .rangeRound RANGE
    .clamp true

  aScale = d3.scale.linear()
    .domain     [ Object.keys(json_data).length-1, 0 ]
    .rangeRound RANGE
    .clamp true

  xAxis = d3.svg.axis()
    .scale xScale
    .orient 'bottom'
    .tickSize RANGE[1]-PADDING/2-20
    .tickFormat d3.format '.0'
    .ticks 7

  yAxis = d3.svg.axis()
    .scale yScale
    .orient 'left'
    .tickSize RANGE[1]-PADDING/2-20
    .tickFormat d3.format '.0'
    .ticks 7

  graph = d3.select '#graph'

  performing2dCompare = -> if sort_stack.length < 2 then 0 else 1
  setLabels = ->
    xLabel.text sort_stack[0]

    if 1 < sort_stack.length 
      yLabel.text sort_stack[1]
    else 
      yLabel.text ''

  xAxisEl = graph.append('g').attr 'id', 'x-axis'
    .attr 'transform', "translate(0,#{PADDING})"
    .call xAxis

  yAxisEl = graph.append('g').attr 'id', 'y-axis'
    .attr 'transform', "translate(#{RANGE[1]},0)"
    .call yAxis
    .style 'opacity', -> performing2dCompare()

  xLabel = xAxisEl.append 'text'
    .attr 'class', 'x-label'
    .attr 'transform', "translate(#{xScale 3},#{RANGE[1]-10})"
    .attr 'text-anchor', 'middle'

  yLabel = yAxisEl.append 'text'
    .attr 'class', 'y-label'
    .attr 'transform', "translate(-#{RANGE[1]-PADDING/2},#{yScale 3}),rotate(-90)"
    .attr 'text-anchor', 'middle'

  combination_points = graph.selectAll 'circle'
    .data d3.entries json_data
    .enter()
    .append 'circle'
    .attr 'cx', xScale 0
    .attr 'cy', yScale 0
    .attr 'r', 5

  detail_view = d3.select '#detail-view'

  combination_points.on 'mouseover', (d) ->

    detail_view.html ->
      char_images = vehicle_images = tire_images = ''

      for c, i in d.value.Options[0]
        char_images     += "<div title='#{c}' alt='#{c}' class='mk8#{c.replace(space_regex, '').replace('.','').toLowerCase()}'></div>"
      for v, i in d.value.Options[1]
        vehicle_images  += "<div title='#{v}' alt='#{v}' class='mk8#{v.replace(space_regex, '').replace('.','').toLowerCase()}body'></div>"
      for t, i in d.value.Options[2]
        tire_images     += "<div title='#{t}' alt='#{t}' class='mk8#{t.replace(space_regex, '').replace('.','').toLowerCase()}tires'></div>"

      """
        <div class='opts'>
          <div class='opt'>#{char_images}</div>
          <div class='opt'>#{vehicle_images}</div>
          <div class='opt'>#{tire_images}</div>
        </div>
        <div class='chart'>
          <div class='bar sub-bar speed-bar'    style='width: #{(d.value["Speed"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar speed-bar'    style='width: #{(d.value["Speed"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar speed-bar'    style='width: #{(d.value["Speed"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar speed-bar'    style='width: #{(d.value["Speed"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar acceleration-bar'     style='width: #{(d.value["Acceleration"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar weight-bar'           style='width: #{(d.value["Weight"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar handling-bar' style='width: #{(d.value["Handling"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar handling-bar' style='width: #{(d.value["Handling"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar handling-bar' style='width: #{(d.value["Handling"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar handling-bar' style='width: #{(d.value["Handling"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar traction-bar'         style='width: #{(d.value["Traction"]) / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar miniturbo-bar'        style='width: #{(d.value["Mini-Turbo"]) / 6 * 100 + '%'}'>&nbsp;</div>
        </div>
      """

  FILTER_RESULTS_WITH_OPACITY = (d, i) ->
    if search_string is null or search_string.test("".concat.apply([].concat.apply([], d.value.OptionsString)))
      1
    else
      0

  d3.select('#filter-search').on 'input.graph', ->
    search_string = new RegExp filter_search.value, 'i'
    combination_points.transition().duration(2000).style 'opacity', FILTER_RESULTS_WITH_OPACITY

  d3.selectAll('form input[type="checkbox"]').on 'click.graph', (c) ->
    if @checked
      sort_stack.push @name 
    else
      for stat, idx in sort_stack when stat is @name
        sort_stack.splice idx, 1

    if 2 < sort_stack.length
      sort_stack.splice 0, sort_stack.length - 2

    for b in boxen
      if sort_stack.indexOf(b.name) is -1
        b.checked = false

    setLabels()
    yAxisEl.transition().duration(1000).style 'opacity', -> performing2dCompare()

    if 1 < sort_stack.length
      rgbInterpolator = d3.interpolateRgb COLOR_TABLE[sort_stack[0]], COLOR_TABLE[sort_stack[1]]
      combination_points
        .attr 'fill', (d) ->
          rgbInterpolator(d.value[sort_stack[1]] / (d.value[sort_stack[0]] + d.value[sort_stack[1]]))
    else
      combination_points
        .attr 'fill', 'white'


    combination_points.transition().duration(1000)
      .attr 'cx', (d, i, el) -> 
        if 0 < sort_stack.length then xScale d.value[sort_stack[0]] else xScale 0
      .attr 'cy', (d, i, el) ->
        if 1 < sort_stack.length then yScale d.value[sort_stack[1]] else aScale i
      .style 'opacity', FILTER_RESULTS_WITH_OPACITY
