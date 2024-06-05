type Cell = (Int,Int)

data MyState = Null | S Cell [Cell] String MyState deriving (Eq,Show)

up :: MyState -> MyState
up (S (row,column) gold string parent)
    | row == 0 = Null
    | otherwise = S (row-1, column) gold "up" (S (row,column) gold string parent)

down :: MyState -> MyState
down (S (row,column) gold string parent)
    | row == 3 = Null
    | otherwise = S (row+1, column) gold "down" (S (row,column) gold string parent)

left :: MyState -> MyState
left (S (row,column) gold string parent)
    | column == 0 = Null
    | otherwise = S (row, column-1) gold "left" (S (row,column) gold string parent)

right :: MyState -> MyState
right (S (row,column) gold string parent)
    | column == 3 = Null
    | otherwise = S (row, column+1) gold "right" (S (row,column) gold string parent)

dig :: MyState -> MyState
dig (S cell gold string parent)
    | cell `elem` gold = S cell (filter (/=cell) gold) "dig" (S cell gold string parent)
    | otherwise = Null

isGoal :: MyState -> Bool
isGoal (S _ gold _ _) = null gold

nextMyStates :: MyState -> [MyState]
nextMyStates currentState = filter (/=Null) [up currentState, down currentState, left currentState, right currentState, dig currentState]

search :: [MyState] -> MyState
search (state:states)
    | isGoal state = state
    | otherwise = search (states ++ nextMyStates state)

constructSolution :: MyState -> [String]
constructSolution (S _ _ string parent) 
    | parent == Null = []
    | otherwise = constructSolution parent ++ [string]

solve :: Cell -> [Cell] -> [String]
solve currentCell goldCells = constructSolution (search [S currentCell goldCells "" Null])
