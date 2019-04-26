import * as p from 'phoenix';
import { Elm } from './elm/Game.elm'

const elmApp = Elm.Game.init({
  node: document.querySelector('.app')
})


// setup socket
let socket = new p.Socket("/socket", {params: {userToken: window.userToken}})
socket.connect()

//let channel = socket.channel("game:lobby", {token: roomToken})
const gameChannelName = "game:" + window.gameId;
console.log('gameChannelName', gameChannelName);
let game_channel = socket.channel(gameChannelName);

game_channel.on('click_update', payload => {
    elmApp.ports.inboudClickPort.send({clicks: payload.clicks});
    console.log('click_update payload', payload);
});

game_channel.on('game_update', payload => {
    console.log('game_update', payload);
    elmApp.ports.inboudGameUpdatePort.send(payload.data);
});

elmApp.ports.clickPort.subscribe(function(data) {
    game_channel.push('click');
});

elmApp.ports.buyPort.subscribe(function(data) {
    console.log('buyPort', data);
    game_channel.push('buy', data);
});

game_channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })
  .receive("timeout", () => console.log("Networking issue..."));

game_channel.onClose( () => console.log("the channel has gone away gracefully") )
game_channel.onError( () => console.log("there was an error!") )
