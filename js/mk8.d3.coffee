L = (things...) -> console.log.apply console, things

ROW_TEMPLATE = """
                <tr><td></td><td></td><td></td><td></td><td></td><td></td></tr>
              """

d3.json '/mk8.min.json', (err, json_data) -> 
  throw 'Error getting data' if err

  this.characters = json_data["Characters"]
  this.vehicles = json_data["Vehicles"]
  this.karts = json_data["Vehicles"]["Karts"]
  this.bikes = json_data["Vehicles"]["Bikes"]
  this.wheels = json_data["Wheels"]

  L characters
  L vehicles
  L wheels

  table_body = d3.select 'tbody'

  table_body.selectAll 'tr'
    .data d3.entries characters
    .enter().append('tr').html (d, i) ->
      "<td>#{d.key}</td><td>#{d.value.Acceleration}</td>"
