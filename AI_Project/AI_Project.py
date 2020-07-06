class driverState:
    def __init__(self, xy, costFromStart):
        self.xy = xy
        self.costFromStart = costFromStart




    def generateValidSuccessors(self):
        xPnt = self.xy[0]
        yPnt = self.xy[1]
        xNorth = xPnt
        yNorth = yPnt + 1
        xSouth = xPnt
        ySouth = yPnt - 1
        xEast = xPnt + 1
        yEast = yPnt
        xWest = xPnt - 1
        yWest = yPnt

        costN = 1
        costS = 1
        costW = 1
        costE = 1

        if xNorth < 0 or xNorth >100 or yNorth < 0 or yNorth > 100:
            costN = 0
        else:
            costN = self.lookup(xNorth , yNorth)

        if xSouth < 0 or xSouth >100 or ySouth < 0 or ySouth > 100:
            costS = 0
        else:
            costS = self.lookup(xSouth , ySouth)

        if xEast < 0 or xEast >100 or yEast < 0 or yEast > 100:
            costE = 0
        else:
            costE = self.lookup(xEast , yEast)

        if xWest < 0 or xWest >100 or yWest < 0 or yWest > 100:
            costW = 0
        else:
            costW = self.lookup(xWest , yWest)
            #print(["cost W is:", costW])



        stateN = driverState([xNorth,yNorth],  self.costFromStart + costN )
        stateS = driverState([xSouth ,ySouth],  self.costFromStart + costS )
        stateE = driverState([xEast ,yEast ],  self.costFromStart + costE )
        stateW = driverState([xWest ,yWest ],  self.costFromStart + costW )

# split the file into lines then iterate through every line and split each line to check for the location
# do it for every direction and return a cost of each direction

        return [['N', costN, stateN], ['E', costE, stateE], ['S', costS, stateS], ['W', costW, stateW]]

    def lookup(self, x, y):
        cnt=0
        with open("input.txt", "r") as f:
            for line in f.readlines():
                cnt=cnt+1
                if cnt ==1 or cnt==2:
                    continue
                array = line.split("\t")
                #print(array[0])
                #print(array[1])
                checkX = int(array[0],10)
                checkY = int(array[1],10)
                if x == checkX:
                    if y == checkY:
                        #print(array[2])
                        #print(array[2][:-2])
                        #if array[2][:-2] == "\n":
                        #print(array[2][:-4])
                        return float(array[2][:-4])
        return 170

class search:
    def __init__(self, startLocation, endLocation):
            self.start = [float(startLocation[0]), float(startLocation[1])]
            self.end = [float(endLocation[0]), float(endLocation[1])]

    def isGoal(self, xy):
        if xy == self.end:
            return 1
        return 0


    def aStarSearch(self):
        from util import PriorityQueue
        expSet = list()
        tempActionSeq = list()
        tempActSeq = ""
        frontier = PriorityQueue()
        print("Start Location: ", self.start, "End Location:", self.end)
        tempState = driverState(self.start, 0)

        i = 0
        while True:
            if frontier.isEmpty():
                #print("frontier empty")
                expSet.append(tempState.xy)
                frontier.push((tempState,""),0)
            else:
                #print(expSet)
                tempNode = frontier.pop()
                #print(tempNode)
                tempState = tempNode[0]
                tempActSeq = tempNode[1]
                if self.isGoal(tempState.xy) == 1:
                    print("last Node: ",[tempState.costFromStart,tempState.xy])
                    return tempActSeq
                for [dir, cost, state] in tempState.generateValidSuccessors():
                    if state.xy in expSet or cost==0:
                        continue
                    expSet.append(state.xy)
                   # newX = x
                    tempActSeq2 = list(tempActSeq)
                    tempActSeq2.append(state.xy)
                    newX = (state, tempActSeq2)
                    #print "tempActSeq: ", newX
                    #print([dir,state.costFromStart,state.xy])
                    frontier.push(newX, state.costFromStart)
                i = i+1

        #with open(<filename>, "r") as f:
            #lines = f.readlines()
        #    array = []
        #    for line in f:
        #        array.append(line)

def main():
    with open("input.txt", "r") as f:
        lines = f.read().split('\n')
        start = lines[0].split('\t')
        end = (lines[1].split('\t'))
        #line1 = f.readline()
        #line2 = f.readline()
        f.close()
    #start[1]=start[1][:-1]
    #end[1]=end[1][:-1]
    #print(start)
    #print(end)
    s = search(start,end)
    sol = s.aStarSearch()
    print("Solution Sequence: ", sol)
    output = open("output.txt", "w")
    for xy in sol:
        output.write("%d %d\n" % (xy[0],xy[1]))
    output.close
    #int_line = int(line1.strip('\n'))
    #int_line2 = int(line2.strip('\n'))
    #print(int_line)
    #print(int_line2)
#    searchObject = search.init(start, end)
#    solution = search.aStarSearch()

    #something = driverState([44, 44], 4)
    #print([44,44])
    #[N, E, S, W] = something.generateValidSuccessors()
    #print(N)
    #print(N[2].xy) #Should print 12 and 14

    #drvr = driverState([5,10],69)
    #x = "44"
    #y = "44"
    #print(drvr.lookup(x,y))


if __name__ == '__main__':
    main()