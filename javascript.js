function test()
{
    alert("Website load test");

    var table = document.getElementsByClassName("whiteTracks").getElementsByTagName('tbody')[0];

    var rows = table.getElementsByTagName("tr");
    for (var i = 1; i < rows.length; i++) { // start from index 1 to skip the header row
      var cells = rows[i].getElementsByTagName("td");
      if (cells[2].textContent > cells[3]) {
        alert("player 1 wins");
      } else if(cells[2].textContent < cells[3]) {
        alert("player 2 wins");
      } else {
        alert("it's a tie");
      };
    };
};