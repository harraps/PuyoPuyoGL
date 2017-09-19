
require "window"
require "canvas"
require "game"
require "player"
require "control"
require "board"
require "block"
require "manager"

export love
export game,canvas

love.load=->
	canvas = Canvas!
	game\addPlayer Player "Name",ControlKeyBoard!
	return

love.draw=->
	for id,player in pairs game.players
		canvas\addBoard player.board,window.x,window.y
		canvas\addBlock player.block,window.x,window.y if player.block~=nil
		canvas\draw window.x,window.y
	return

love.update=->
	for id,player in pairs game.players
		player\update!
	return