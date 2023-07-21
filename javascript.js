function test()
{
    alert("Website load test");

    var table = document.getElementsByClassName("whiteTracks")[0].getElementsByTagName('tbody')[0];

    var rows = table.getElementsByTagName("tr");
    for (var i = 0; i < 1; i++) { // start from index 1 to skip the header row
        var cells = rows[i].getElementsByTagName("td");
        alert(cells[1].textContent);
    };
};

test();