
export ^ --export classes

--compress col and row
--compact=(col,row)-> (col<<4)|row
compact=(col,row)-> (col*16) + row

class Manager
    new:(board)=>
        @board = board
        @groups = {}
        @dirty = false
    
    manage:(col1,row1,col2,row2)=>
        --no contact with floor
        return if col1==nil or row1==nil or col2==nil or row2==nil
        --find puyo to destroy
        mark1 = @mark @group col1,row1
        mark2 = @mark @group col2,row2
        @dirty = mark1 or mark2
        return

    gather:=>
        @groups,marked = {},false
        for x=1,6
            for y=1,12
                id = compact x,y
                continue if @find id
                group = @group x,y
                @groups[group] = true
                marked = true if @mark group
        return marked

    find:(id)=>
        for group in pairs @groups
            return true if group[id]~=nil
        return false

    mark:(group)=>
		count,marked = 0,false
		count+=1 for _ in pairs group
		if count >= 4
			marked = true
			for _,pos in pairs group
				@board\remove pos.col,pos.row
		return marked

    --group of puyo to delete
	group:(col,row)=>
		puyo,group = (@board\puyo col,row),{}
		@_group puyo,group,col,row if puyo~=nil
		return group
		
	_group:(puyo,group,col,row)=>
		puyo2 = @board\puyo col,row
		if puyo==puyo2
			id = compact col,row
			if group[id]==nil
				group[id] = {col:col,row:row}
				@_group puyo,group,col  ,row+1
				@_group puyo,group,col-1,row
				@_group puyo,group,col+1,row
				@_group puyo,group,col  ,row-1
        return