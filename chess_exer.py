import sys

class Board(object):
    X = ['a','b','c','d','e','f','g','h']
    Y = [1,2,3,4,5,6,7,8]

    def __init__(self, coordinates):
        if self.layout_check(coordinates):
            
            self.pos_alfa = coordinates[0]
            self.pos_num = int(coordinates[1])
            # self.all = self.all_blocks

    def layout_check(self, pos):
        
        deal_x = lambda x : x in self.X
        deal_y = lambda y : y in self.Y
        
        if deal_x(pos[0]) == True & deal_y(int(pos[1])) == True:
            return pos[0], int(pos[1])
        else:
            return False

    def all_blocks(self):
        new_x = (chr(ord(self.pos_alfa) - 1), self.pos_alfa, chr(ord(self.pos_alfa) + 1))
        new_y = (self.pos_num-1, self.pos_num, self.pos_num + 1)
        return [x + str(y) for x in new_x for y in new_y]

    def edge_blocks(self):
        all = self.all_blocks()
        return [all[0],all[2],all[6],all[8]]

    def corner_blocks(self):
        all = self.all_blocks()
        return list(set(all) - set(self.edge_blocks()))
    
    
def filter_results(result):
    X = ['a','b','c','d','e','f','g','h']
    Y = [1,2,3,4,5,6,7,8]
    all_possibiliites = [x+ str(y) for x in X for y in Y]
    return [x for x in result if x in all_possibiliites]


def knight_possibilities(corners, all):
    all_poss = ()
    for i in corners:
        k = Board(i)
        all_poss += tuple(set(k.edge_blocks()) - set(all))
    return filter_results(all_poss)

if __name__ == "__main__":
    name = sys.argv[1]
    pos = sys.argv[2]
    print name , pos
    
    try:
        given = Board(pos)
        # print given.edge_blocks()
        # print given.corner_blocks()
        if name.startswith('k'):
            print knight_possibilities(given.corner_blocks(), given.all_blocks())
        
    except Exception, e:
        print e
        print "Something went wrong with your input."