
const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
const medals = ['⭐', '🥈', '🥉'];

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


///////////////////////////////////////////////////////////////////////////////

const fs = require('fs');
const csvFilePath = 'data.csv';

// Function to convert time format "mm:ss.ms" to milliseconds
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

// Function to add an array of time values in "mm:ss.ms" format
function addTimes(timeArray) {
    if (!Array.isArray(timeArray) || timeArray.length === 0) {
        throw new Error('Invalid input: timeArray should be a non-empty array of time values.');
    }

    // Convert time values to milliseconds and sum them
    const totalMilliseconds = timeArray.reduce((acc, time) => acc + timeToMilliseconds(time), 0);

    // Convert the total milliseconds back to "mm:ss.ms" format
    return millisecondsToTime(totalMilliseconds);
}

fs.readFile(csvFilePath, 'utf8', (err, data) => {
    if (err) {
        console.error('Error reading the file:', err);
        return;
    }

    const rows = data.trim().split('\n');
    let totalMillisecondsWhitePaul = 0;
    let totalMillisecondsWhiteAidan = 0;
    let totalMillisecondsWhiteDarren = 0;

    let totalMillisecondsGreenPaul = 0;
    let totalMillisecondsGreenAidan = 0;
    let totalMillisecondsGreenDarren = 0;
    
    let totalMillisecondsBluePaul = 0;
    let totalMillisecondsBlueAidan = 0;
    let totalMillisecondsBlueDarren = 0;

    let totalMillisecondsRedPaul = 0;
    let totalMillisecondsRedAidan = 0;
    let totalMillisecondsRedDarren = 0;


    const timeValues = [];


    for (let i = 1; i < Math.min(rows.length, 31); i++) {

        let row = rows[i].trim();

        if (row.endsWith('\r')) {
            row = row.slice(0, -1); // Remove the trailing \r
        }

        const columns = row.split(',');


        if (i >= 16 && i <= 31) { // green tracks

            const greenPaul = columns[2].trim();
            const greenAidan = columns[3].trim();
            const greenDarren = columns[4].trim();

            //console.log(greenPaul)

            totalMillisecondsGreenPaul += timeToMilliseconds(greenPaul);
            totalMillisecondsGreenAidan += timeToMilliseconds(greenAidan);
            totalMillisecondsGreenDarren += timeToMilliseconds(greenDarren);

        }

        else if(i >= 31 && i <= 46) { // blue tracks

            const BluePaul = columns[2].trim();
            const BlueAidan = columns[3].trim();
            const BlueDarren = columns[4].trim();

            //console.log(BluePaul)

            totalMillisecondsBluePaul += timeToMilliseconds(BluePaul);
            totalMillisecondsBlueAidan += timeToMilliseconds(BlueAidan);
            totalMillisecondsBlueDarren += timeToMilliseconds(BlueDarren);

        }

        else if (i >= 31 && i <= 46) { // red tracks

            const RedPaul = columns[2].trim();
            const RedAidan = columns[3].trim();
            const RedDarren = columns[4].trim();

            //console.log(RedPaul)

            totalMillisecondsRedPaul += timeToMilliseconds(RedPaul);
            totalMillisecondsRedAidan += timeToMilliseconds(RedAidan);
            totalMillisecondsRedDarren += timeToMilliseconds(RedDarren);


        }
        else { // white tracks

            const whitePaul = columns[2].trim();
            const whiteAidan = columns[3].trim();
            const whiteDarren = columns[4].trim();

            // Convert time values to milliseconds and add to the respective variables
            totalMillisecondsWhitePaul += timeToMilliseconds(whitePaul);
            totalMillisecondsWhiteAidan += timeToMilliseconds(whiteAidan);
            totalMillisecondsWhiteDarren += timeToMilliseconds(whiteDarren);
        }

    }

    const totalTimeWhitePaul = millisecondsToTime(totalMillisecondsWhitePaul);
    const totalTimeWhiteAidan = millisecondsToTime(totalMillisecondsWhiteAidan);
    const totalTimeWhiteDarren = millisecondsToTime(totalMillisecondsWhiteDarren);

    const totalTimeGreenPaul = millisecondsToTime(totalMillisecondsGreenPaul);
    const totalTimeGreenAidan = millisecondsToTime(totalMillisecondsGreenAidan);
    const totalTimeGreenDarren = millisecondsToTime(totalMillisecondsGreenDarren);

    const totalTimeBluePaul = millisecondsToTime(totalMillisecondsBluePaul);
    const totalTimeBlueAidan = millisecondsToTime(totalMillisecondsBlueAidan);
    const totalTimeBlueDarren = millisecondsToTime(totalMillisecondsBlueDarren);

    const totalTimeRedPaul = millisecondsToTime(totalMillisecondsRedPaul);
    const totalTimeRedAidan = millisecondsToTime(totalMillisecondsRedAidan);
    const totalTimeRedDarren = millisecondsToTime(totalMillisecondsRedDarren);


    console.log('White (Paul):', totalTimeWhitePaul);
    console.log('Green (Paul):', totalTimeGreenPaul);
    console.log('Blue (Paul):', totalTimeBluePaul);
    console.log('Red (Paul):', totalTimeRedPaul);
    console.log()
    console.log('White (Aidan):', totalTimeWhiteAidan);
    console.log('Green (Aidan):', totalTimeGreenAidan);
    console.log('Blue (Aidan):', totalTimeBlueAidan);
    console.log('Red (Aidan):', totalTimeRedAidan);
    console.log()
    console.log('White (Darren):', totalTimeWhiteDarren);
    console.log('Green (Darren):', totalTimeGreenDarren);
    console.log('Blue (Darren):', totalTimeBlueDarren);
    console.log('Red (Darren):', totalTimeRedDarren);

});



