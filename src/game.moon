
export ^ --export classes

class Game
    new:=>
        @players = {}
        return
    
    addPlayer:(player)=>
        table.insert @players,player
        return
--end Game

export game = Game!