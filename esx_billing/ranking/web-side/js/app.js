const app = {
  open: (ranking, plyRank) => {
    $('body').show();
    app.showRank(ranking);
    app.showPlyRank(plyRank);

  },
  close: () => {
    $('body').hide();
  },
  showPlyRank: (data) => {
    $('#plyName').html(data["username"]);
    $('#plyKills').html(data["kills"]);
    $('#plyDeaths').html(data["deaths"]);
    $('#plyRanking').html(data["plyRanking"]);
    $('#plyKd').html(data["kills_deaths"]);

  },
  showRank: (ranking) => {
    for (var i in ranking) {
      $('table').append(templateRanking(i, ranking[i]));
    }
  }
};

window.addEventListener('message', ({ data }) => {
  if (data.show) {
    app.open(data.ranking, data.plyRanking);
  } else {
    app.close();
    window.location.reload();
  }
})

document.onkeyup = function (data) {
  if (data["which"] == 27) {
    fetch('http://esx_billing/closeUi')
  }
};

const templateRanking = (i, data) => {
  i = parseInt(i) + 1

  return `
    <tr>
      <td>${i}</td>
      <td><p>${data["username"]}</p></td>
      <td>${data["kills"]}</td>
      <td>${data["deaths"]}</td>
      <td>${data["kills_deaths"]}</td>
    </tr>
  `;
};
