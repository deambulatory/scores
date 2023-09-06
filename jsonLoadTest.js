fetch('./data.json').then(response => {
    return response.json();
  }).then(data => {
    parseJson(data);
  });
  
  function parseJson(json) {
    for (let x in json.tracks) {
      console.log(json.tracks[x].name);
    }
  
    //loop through the tracks
    //set up new table when new track type
    //add names to the table as rows
    //loop through player times and add the track time to the table
    console.log(json.uiModels.trackTable)
    for (let trackTypes in json.uiModels.trackTable.names) {
      tt = json.uiModels.trackTable.names[trackTypes]
      console.log(tt)
    }
  };