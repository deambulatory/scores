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
runWhiteTrackComparison();
runGreenTrackComparison();