function runWhiteTrackComparison()
{
    var score = [0, 0];

    var table = document.getElementsByClassName("whiteTracks")[0].getElementsByTagName('tbody')[0];

    var rows = table.getElementsByTagName("tr");
    for (var i = 0; i < rows.length; i++) { // start from index 1 to skip the header row
        var cells = rows[i].getElementsByTagName("td");
        var classToAdd = "";

        //player 1 wins -> player 2 wins -> draw
        if(cells[1].textContent < cells[2].textContent) {
            score[0] += 1;
            classToAdd = "player1";
            cells[1].classList.add("bold");
        } else if(cells[2].textContent < cells[1].textContent) {
            score[1] += 1;
            classToAdd = "player2";
            cells[2].classList.add("bold");
        } else {
            score[0] += 1;
            score[1] += 1;
            classToAdd = "draw";
            cells[1].classList.add("bold");
            cells[2].classList.add("bold");
        };
        cells[3].textContent = score[0]+"-"+score[1];

        cells[1].classList.add(classToAdd);
        cells[2].classList.add(classToAdd);
        cells[3].classList.add(classToAdd);
    };

};

function runGreenTrackComparison()
{
    var score = [0, 0];

    var table = document.getElementsByClassName("greenTracks")[0].getElementsByTagName('tbody')[0];

    var rows = table.getElementsByTagName("tr");
    for (var i = 0; i < rows.length; i++) { // start from index 1 to skip the header row
        var cells = rows[i].getElementsByTagName("td");
        var classToAdd = "";

        //player 1 wins -> player 2 wins -> draw
        if(cells[1].textContent < cells[2].textContent) {
            score[0] += 1;
            classToAdd = "player1";
            cells[1].classList.add("bold");
        } else if(cells[2].textContent < cells[1].textContent) {
            score[1] += 1;
            classToAdd = "player2";
            cells[2].classList.add("bold");
        } else {
            score[0] += 1;
            score[1] += 1;
            classToAdd = "draw";
            cells[1].classList.add("bold");
            cells[2].classList.add("bold");
        };
        cells[3].textContent = score[0]+"-"+score[1];

        cells[1].classList.add(classToAdd);
        cells[2].classList.add(classToAdd);
        cells[3].classList.add(classToAdd);
    };

};
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

                for (var j = 1; j < headers.length; j++) {
                    let td = tr.insertCell();

                    if(data[j] !== "") {
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
// Check if the user is on a mobile device
const isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);

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