'use strict';

L = (things...) -> console.log.apply console, things

boxen = document.querySelectorAll 'form input'
halptaxt = document.querySelector '.halptaxt'
stats = document.querySelectorAll '.stat'

DISPLAY_AMOUNT = 2

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
    L err
    throw new Error 'Error getting data'

  rows = d3.select('#listing')
    .selectAll('div')
    .data(d3.entries json_data)
    .enter()
    .append('div')
    .html (d, i) ->
      char_images = []
      vehicle_images = []
      tire_images = []
      space_regex = `/ /g` #because mutiple-replacement only works with regexs

      for c in d.value.Options[0]
        char_images.push "<img title='#{c}' alt='#{c}' src='img/#{c.replace(space_regex, '').replace('.','')}.png' height='64px' width='64px'/>"
      for v in d.value.Options[1]
        vehicle_images.push "<img title='#{v}' alt='#{v}' src='img/#{v.replace(space_regex, '').replace('.','')}Body.png' height='64px' width='100px'/>"
      for t in d.value.Options[2]
        tire_images.push "<img title='#{t}' alt='#{t}' src='img/#{t.replace(space_regex, '').replace('.','')}Tires.png' height='64px' width='100px'/>"

      """
        <div class='combo-details'>
          <div style='visibility:hidden' class='combo'>#{d.key}</div>
          <div class='opts hide'>
            <div class='opt charopts'>#{char_images.join ""}</div>
            <div class='opt vehicleopts'>#{vehicle_images.join ""}</div>
            <div class='opt wheelsopts'>#{tire_images.join ""}</div>
            <hr/>
          </div>
          <div style='display:none' class='optnames'>
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
                  <th>Ground</th>
                  <th>Water</th>
                  <th>Air</th>
                  <th>Anti-Gravity</th>
                  <th></th>
                  <th></th>
                  <th>Ground</th>
                  <th>Water</th>
                  <th>Air</th>
                  <th>Anti-Gravity</th>
                  <th></th>
                  <th></th>
              </tr>
            </thead>
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
          </table>
        </div>
        <div class='chart'>
          <div class='bar sub-bar' style='width: #{d.value["Speed"]["Ground"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar' style='width: #{d.value["Speed"]["Water"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar' style='width: #{d.value["Speed"]["Air"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar' style='width: #{d.value["Speed"]["Anti-Gravity"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar'         style='width: #{d.value["Acceleration"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar'         style='width: #{d.value["Weight"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar' style='width: #{d.value["Handling"]["Ground"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar' style='width: #{d.value["Handling"]["Water"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar' style='width: #{d.value["Handling"]["Air"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar sub-bar' style='width: #{d.value["Handling"]["Anti-Gravity"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar'         style='width: #{d.value["Traction"] / 6 * 100 + '%'}'>&nbsp;</div>
          <div class='bar'         style='width: #{d.value["Mini-Turbo"] / 6 * 100 + '%'}'>&nbsp;</div>
        </div>

        <br style='clear:both';/>
      """
    .classed('row', true)
    # TODO: change this to a delegate
    .each (d, i) ->
      this.addEventListener 'click', (e) ->
        if 'true' == this.getAttribute 'data-toggle'
          this.setAttribute 'data-toggle', 'false'
          this.querySelector('.optnames').setAttribute 'style', 'display: none'
          this.querySelector('.stat').removeAttribute 'style'
        else
          this.setAttribute 'data-toggle', 'true'
          this.querySelector('.optnames').setAttribute 'style', 'display: block'
          this.querySelector('.stat').setAttribute 'style', 'opacity: 1'
      
      @.classList.add 'hide'


  d3.selectAll('form input').data(d3.entries json_data).on 'click', (c) ->

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

    d3.selectAll('.row')
    .each (d, i) ->
      @.classList.add 'hide'
    .sort (a, b) ->
      score(b.value, sorting_by) - score(a.value, sorting_by)
    .each (d, i) ->
      if i < DISPLAY_AMOUNT
        @.classList.remove 'hide'
