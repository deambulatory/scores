// Check if the user is on a mobile device
const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);

const medals = ['🥇', '🥈', '🥉'];

// If not on a mobile device, add the click event listener
if (!isMobile) {

    // Get a reference to the downloadCell
    const downloadCells = document.querySelectorAll(".downloadCell");

    downloadCells.forEach((cell) => {
        cell.addEventListener("click", () => {
            const fileName = cell.getAttribute("data-file");
            const userConfirmation = window.confirm("Do you want to download the replay for " + cell.textContent + "?");

            if (userConfirmation) { downloadFile(fileName); }
            else { }
        });
    });

    function downloadFile(fileName) {

        const fileURL = 'https://github.com/deambulatory/scores/raw/main/Replays/' + fileName;
        const link = document.createElement('a');
        link.href = fileURL;
        link.download = fileName;
        link.click();
    }
}

$(document).ready(function() {
    $.ajax({
        type: "GET",
        url: "data.csv",
        dataType: "text",
        success: function(data) {
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
                
                th.colSpan = headers.length-1;
                th.innerHTML = trackType;

                let tr2 = header.insertRow();

                for(k = 1; k < headers.length; k++) {
                    let th = tr2.appendChild(document.createElement("th"));
                    th.innerHTML = headers[k];
                };

            };

            if (data.length == headers.length) {
                let tr = newTable.insertRow();

                let sortedTimes = getTopThree(data);

                for (var j = 1; j < headers.length; j++) {
                    let td = tr.insertCell();

                    if(data[j] !== "") {
                        if(medals[sortedTimes.indexOf(data[j])]) {
                            td.appendChild(medals[sortedTimes.indexOf(data[j])]+" ");
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
    let sortedTimes = arr;

    //remove the track name and track type
    sortedTimes.splice(0,2);

    //remove blanks
    sortedTimes = sortedTimes.filter(n => n);

    //sort the array, remove any duplicates and truncate to top 3
    var tafixed =   [...sortedTimes].sort()
        .filter((v,i,self) => self.indexOf(v) === i)
        .slice(0, 3);
    
    return tafixed
};
//🥇🥈🥉