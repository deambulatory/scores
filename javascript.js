
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
    const milliseconds = parseInt(match[3] + "0");

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
        var trackType = "";
        var newTable = "";
        var timesTotal = [];
        var timeCheck = [];
        
        //TODO:
        //load data from nadeoTimes into a 2d array
        //when times are read in, compare to nadeo array
        //if times lower than nadeo then nadeo medal, cascade down to bronze
        //create a new table with players in cols, tracks in rows, medal type in cell
        //add up total and display, total nadeo, gold, silver, bronze
        //260 medals in total, 4 per 65 maps
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

                th.classList.add(trackType);

                let tr2 = header.insertRow();

                for (k = 1; k < headers.length; k++) {
                    let th = tr2.appendChild(document.createElement("th"));
                    th.innerHTML = headers[k];
                };
                
                //adds new row to the timesTotal array filled with x amount for x people in the csv
                timesTotal.push(new Array(headers.length-2).fill(0));
                timeCheck.push(new Array(headers.length-2).fill(true));
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
                        timeCheck[timeCheck.length-1][j-2] = false;
                    };

                };
            };

            document.body.appendChild(newTable);
        };

        //total times table code
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

            let sortedTimes = getTopThreeTotal(timesTotal[x], timeCheck[x]);

            td.textContent = tracks[x];

            for(y=0; y<timesTotal[x].length; y++) {
                //add time to table
                let td1 = tr.insertCell();

                if (medals[sortedTimes.indexOf(timesTotal[x][y])]) {
                    td1.appendChild(document.createTextNode(medals[sortedTimes.indexOf(timesTotal[x][y])] + " "));
                };

                timesTotal[x][y] = millisecondsToTime(timesTotal[x][y]);
                td1.appendChild(document.createTextNode(timesTotal[x][y]));
            };
        };

        //console.log(timesTotal);
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

function getTopThreeTotal(arr, checkArr) {
    let sortedTimes2 = [];

    console.log(arr);
    console.log(checkArr);

    console.log(sortedTimes2);

    
    for(z=0; z<arr.length; z++) {
        if(checkArr[z]===true) {
            sortedTimes2.push(arr[z]);
        };
    };
    
    console.log(arr.length-1);
    console.log(sortedTimes2);


    //remove blanks
    sortedTimes2 = sortedTimes2.filter(n => n);

    //sort the array, remove any duplicates and truncate to top 3
    var tafixed2 = [...sortedTimes2].sort()
        .filter((v, i, self) => self.indexOf(v) === i)
        .slice(0, 3);

    return tafixed2
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