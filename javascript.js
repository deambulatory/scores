
const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
const medals = ['⭐', '🥈', '🥉'];
const tracks = ["White", "Green", "Blue", "Red", "Black"]; // hacky track totals, need to convert places used dynamically instead (if we add more tracks or games etc)

function timeToMilliseconds(time) {
    const timeRegex = /^(\d{2}):(\d{2})\.(\d{2,3})$/;
    const match = time.match(timeRegex);

    if (!match) {
        throw new Error(`Invalid time format: ${time}. Time should be in the format "mm:ss.ms".`);
    }

    const minutes = parseInt(match[1]);
    const seconds = parseInt(match[2]);
    const milliseconds = parseInt(match[3]);

    if (isNaN(minutes) || isNaN(seconds) || isNaN(milliseconds)) {
        throw new Error(`Invalid time format: ${time}. Unable to parse time values.`);
    }

    return minutes * 60000 + seconds * 1000 + milliseconds;
}

// Function to convert milliseconds to time format "mm:ss.ms"
function millisecondsToTime(milliseconds) {
    const minutes = Math.floor(milliseconds / 60000);
    const seconds = Math.floor((milliseconds % 60000) / 1000);
    const remainingMilliseconds = milliseconds % 1000;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}.${remainingMilliseconds.toString().padStart(3, '0').slice(0, 2)}`;
}

$(document).ready(function () {
    $.ajax({
        type: "GET",
        url: "data.csv",
        dataType: "text",
        success: function (data) {
            processData(data);
        }
    });


    function processData(allText) {
        var allTextLines = allText.split(/\r\n|\n/);
        var headers = allTextLines[0].split(',');
        var lines = [];
        var trackType = "";
        var newTable = "";
        var timesTotal = [];
        
        for (var i = 1; i < allTextLines.length; i++) {
            var data = allTextLines[i].split(',');

            if (data[0] != trackType) {
                newTable = document.createElement("TABLE");
                trackType = data[0];

                let header = newTable.createTHead();
                let tr = header.insertRow();
                let th = tr.appendChild(document.createElement("th"));

                th.colSpan = headers.length - 1;
                th.innerHTML = trackType;
                th.style.fontSize = "16px";

                
                switch (trackType) {
                    case "White":
                        th.style.backgroundColor = "White";
                        break;
                    case "Green":
                        th.style.backgroundColor = "#32CD32";
                        break;
                    case "Blue":
                        th.style.backgroundColor = "#0096FF";
                        break;
                    case "Red":
                        th.style.backgroundColor = "Red";
                        break;
                    case "Black":
                        th.style.backgroundColor = "Black";
                        th.style.color = "white"
                        break;
                }

                let tr2 = header.insertRow();

                for (k = 1; k < headers.length; k++) {
                    let th = tr2.appendChild(document.createElement("th"));
                    th.innerHTML = headers[k];
                };
                
                //adds new row to the timesTotal array filled with x amount for x people in the csv
                timesTotal.push(new Array(headers.length-2).fill(0));
            };

            if (data.length == headers.length) {
                let tr = newTable.insertRow();

                let sortedTimes = getTopThree(data);

                for (var j = 1; j < headers.length; j++) {
                    let td = tr.insertCell();

                    if (data[j] !== "") {

                        const pattern = /^[A-Za-z]\d{2}$/;

                        if (pattern.test(data[j])) {

                            td.classList.add("downloadCell");
                            td.setAttribute("data-file", data[j]);

                        } else {
                           timesTotal[timesTotal.length-1][j-2] += timeToMilliseconds(data[j]);
                        }

                        if (medals[sortedTimes.indexOf(data[j])]) {
                            td.appendChild(document.createTextNode(medals[sortedTimes.indexOf(data[j])] + " "));
                        };

                        td.appendChild(document.createTextNode(data[j]));

                    } else {
                        td.appendChild(document.createTextNode("--:--.--"));
                    };

                };
            };

            document.body.appendChild(newTable);
        };

        //needs updating to automatically accomodate for all members of the CSV

        let times = [[0,0,0,0,0], [0,0,0,0,0], [0,0,0,0,0]]        
        var lines = [];

        for (var i = 1; i < allTextLines.length; i++) {
            var data = allTextLines[i].split(',');
            lines.push(data);
        }

        // needs updating to accomodatte for blank time values

        for (var i = 0; i < 60; i++) { // needs updating to 66 to include black tracks

            if (i > 14 && i < 30) { // green tracks

                const greenPaul = lines[i][2];
                const greenAidan = lines[i][3];
                const greenDarren = lines[i][4];

                times[0][1] += timeToMilliseconds(greenPaul);
                times[1][1]+= timeToMilliseconds(greenAidan);
                times[2][1] += timeToMilliseconds(greenDarren);
            }

            else if (i > 29 && i < 45) {

                const BluePaul = lines[i][2];
                const BlueAidan = lines[i][3];
                const BlueDarren = lines[i][4];

                
                times[0][2] += timeToMilliseconds(BluePaul);
                times[1][2] += timeToMilliseconds(BlueAidan);
                //totalMillisecondsBlueDarren += timeToMilliseconds(BlueDarren);
 
  
             }
            else if (i > 44 && i < 61) {
                
                const redPaul = lines[i][2];
                const redAidan = lines[i][3];
                const redDarren = lines[i][4];
                    
                times[0][3] += timeToMilliseconds(redPaul);
                times[1][3] += timeToMilliseconds(redAidan);
                //totalMillisecondsRedDarren += timeToMilliseconds(redDarren);

             }
            else {

                const whitePaul = lines[i][2];
                const whiteAidan = lines[i][3];
                const whiteDarren = lines[i][4];

                times[0][0] += timeToMilliseconds(whitePaul);
                times[1][0] += timeToMilliseconds(whiteAidan);
                times[2][0] += timeToMilliseconds(whiteDarren);

            }

        }

        const totalTimeWhitePaul = millisecondsToTime(times[0][0]);
        const totalTimeWhiteAidan = millisecondsToTime(times[1][0]);
        const totalTimeWhiteDarren = millisecondsToTime(times[2][0]);

        const totalTimeGreenPaul = millisecondsToTime(times[0][1]);
        const totalTimeGreenAidan = millisecondsToTime(times[1][1]);
        const totalTimeGreenDarren = millisecondsToTime(times[2][1]);
        
        const totalTimeBluePaul = millisecondsToTime(times[0][2]);
        const totalTimeBlueAidan = millisecondsToTime(times[1][2]);
        const totalTimeBlueDarren = millisecondsToTime(times[2][2]);

        const totalTimeRedPaul = millisecondsToTime(times[0][3]);
        const totalTimeRedAidan = millisecondsToTime(times[1][3]);
        const totalTimeRedDarren = millisecondsToTime(times[2][3]);

        newTable = document.createElement("TABLE");
        //document.body.appendChild(newTable); Removes Paul total time table
        let header = newTable.createTHead();
        let tr = header.insertRow();
        let th = tr.appendChild(document.createElement("th"));

        th.colSpan = headers.length - 1;
        th.innerHTML = "Total Times";
        th.style.fontSize = "16px";
        th.style.backgroundColor = "#FFD580";

        let tr2 = header.insertRow();

        for (k = 1; k < headers.length; k++) {
            let th = tr2.appendChild(document.createElement("th"));
            
            if(headers[k]) {
                th.innerHTML = headers[k];
            }
        }

       // this needs updating so it isn't hardcoded

        const WhiteTimes = ['🥈 ' + totalTimeWhitePaul, '⭐ ' + totalTimeWhiteAidan,'🥉 ' + totalTimeWhiteDarren];
        const GreenTimes = ['🥈 ' + totalTimeGreenPaul, '⭐ ' + totalTimeGreenAidan, '🥉 ' + totalTimeGreenDarren];
        const BlueTimes = ['🥈 ' +totalTimeBluePaul, '⭐ ' + totalTimeBlueAidan, '--:--.--'];
        const RedTimes = ['⭐ ' + totalTimeRedPaul, '🥈 ' + totalTimeRedAidan, '--:--.--'];
        const BlackTimes = ['--:--.--', '--:--.--', '--:--.--'];

        // Create table rows for each time variable

        const totalTimesData = [
            { column: 'White', times: WhiteTimes },
            { column: 'Green', times: GreenTimes },
            { column: 'Blue', times: BlueTimes },
            { column: 'Red', times: RedTimes },
            { column: 'Black', times: BlackTimes },
        ];

        totalTimesData.forEach((data) => {
            const row = newTable.insertRow();
            const cell1 = row.insertCell();

            cell1.textContent = data.column;

            // Insert times for each column
            data.times.forEach((time) => {
                const cell = row.insertCell();
                cell.textContent = time;
            });

            // Fill remaining cells with placeholders if there are less than three times
            const numOfPlaceholders = 3 - data.times.length;
            for (let i = 0; i < numOfPlaceholders; i++) {
                const cell = row.insertCell();
                cell.textContent = '--:--.--';
            }
        });

        var newTable1 = document.createElement("TABLE");
        document.body.appendChild(newTable1);

        let header1 = newTable1.createTHead();
        let tr1 = header1.insertRow();
        let th1 = tr1.appendChild(document.createElement("th"));

        th1.colSpan = headers.length - 1;
        th1.innerHTML = "Total Times";
        th1.style.fontSize = "16px";
        th1.style.backgroundColor = "#FFD580";

        let tr3 = header1.insertRow();

        for (k = 1; k < headers.length; k++) {
            let th1 = tr3.appendChild(document.createElement("th"));
            
            if(headers[k]) {
                th1.innerHTML = headers[k];
            }
        }

        //loop through our timesTotal array, placing them into the table
        for(x=0; x<timesTotal.length; x++) {
            //add row to table
            let tr = newTable1.insertRow();
            //add track name
            let td = tr.insertCell();

            let sortedTimes = getTopThreeTotal(timesTotal[x]);

            td.textContent = tracks[x];

            for(y=0; y<timesTotal[x].length; y++) {
                //add time to table
                let td1 = tr.insertCell();

                console.log("Sorted times:", sortedTimes);
                console.log("current time:", timesTotal[x][y]);

                console.log(sortedTimes.indexOf(timesTotal[x][y]));

                if (medals[sortedTimes.indexOf(timesTotal[x][y])]) {
                    td1.appendChild(document.createTextNode(medals[sortedTimes.indexOf(timesTotal[x][y])] + " "));
                };

                timesTotal[x][y] = millisecondsToTime(timesTotal[x][y]);
                td1.textContent = timesTotal[x][y];
            };
        };

        console.log(timesTotal);
    };
});

function getTopThree(arr) {
    let sortedTimes = [...arr];

    //remove the track name and track type
    sortedTimes.splice(0, 2);

    //remove blanks
    sortedTimes = sortedTimes.filter(n => n);

    //sort the array, remove any duplicates and truncate to top 3
    var tafixed = [...sortedTimes].sort()
        .filter((v, i, self) => self.indexOf(v) === i)
        .slice(0, 3);

    return tafixed
};

function getTopThreeTotal(arr) {
    let sortedTimes = [...arr];

    //remove blanks
    sortedTimes = sortedTimes.filter(n => n);

    //sort the array, remove any duplicates and truncate to top 3
    var tafixed = [...sortedTimes].sort()
        .filter((v, i, self) => self.indexOf(v) === i)
        .slice(0, 3);

    return tafixed
};

if (!isMobile) {
    // Add event listener to the document, delegating to cells with the "downloadCell" class
    document.addEventListener("click", function (event) {
        const clickedElement = event.target;
        // Check if the clicked cell is in the first column (first child of the row)
        if (clickedElement.classList.contains("downloadCell") && clickedElement.parentElement.firstChild === clickedElement) {
            const fileName = clickedElement.getAttribute("data-file");
            const userConfirmation = window.confirm("Do you want to download the replay for " + clickedElement.textContent + "?");

            if (userConfirmation) {
                downloadFile(fileName);
            } else {
                // Handle case when the user cancels the download
            }
        }
    });

    function downloadFile(fileName) {

        const fileURL = 'https://github.com/deambulatory/scores/raw/main/Replays/' + fileName + '.gbx';
        const link = document.createElement('a');
        link.href = fileURL;
        link.download = fileName;
        link.click();
    }
}