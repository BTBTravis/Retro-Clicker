import * as p from 'phoenix';

// setup socket
let socket = new p.Socket("/socket", {params: {userToken: window.userToken}})
socket.connect()


//let channel = socket.channel("game:lobby", {token: roomToken})
const clickBtnEl = document.querySelector('.js-click-btn');
const clickCountEl = document.querySelector('.js-click-count');
const gameChannelName = "game:" + window.gameId;
console.log('gameChannelName', gameChannelName);
let game_channel = socket.channel(gameChannelName);

game_channel.on("click_update", payload => {
    clickCountEl.textContent = payload.clicks;
    console.log('click_update payload', payload);
});

clickBtnEl.addEventListener('click', () => {
    clickCountEl.textContent = parseInt(clickCountEl.textContent) + 1;
    game_channel.push("click");
});
game_channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
  .receive("timeout", () => console.log("Networking issue..."));

game_channel.onClose( () => console.log("the channel has gone away gracefully") )
game_channel.onError( () => console.log("there was an error!") )

