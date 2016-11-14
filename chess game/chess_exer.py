import sys

class Board(object):
    X = ['a','b','c','d','e','f','g','h']
    Y = [1,2,3,4,5,6,7,8]

    def __init__(self, coordinates):
        if self.layout_check(coordinates):
            self.pos_alfa = coordinates[0]
            self.pos_num = int(coordinates[1])
            
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

    def veritical_dir(self):
        return [self.pos_alfa +str(x) for x in self.Y]

    def horizontal_dir(self):
        return [x + str(self.pos_num) for x in self.X]
    
    def corner_dir(self):
        # horz = self.horizontal_dir()
        # hor = [horz[0], horz[-1]]
        leng = len(self.X[self.X.index(self.pos_alfa):])
        # k = [x+str(y)  for x in  self.X[self.pos_num -1 :] for y in self.Y[self.pos_num:]]
        # print leng
        # right up
        right_total_up = leng + self.pos_num
        # print right_total_up , "ioooo"
        if (8 -right_total_up) < 0:
            right_up_coord = self.X[8-right_total_up]+str(8)
        else:
            right_up_coord = 'h' + str(right_total_up-1) 
        # right down
        right_total_down = leng - self.pos_num
        # print right_total_down

        if right_total_down >= 0 :
            right_down_coord = self.X[-right_total_down-1] + str(1)
        else: 
            right_down_coord = 'h' + str(self.Y[-right_total_down])
        
        # left_up
        left_up_total = 8 - leng  + self.pos_num
        # print left_up_total
        if left_up_total - 8  >= 0 :
            left_up_coord =  self.X[left_up_total - 8  ] + str(8)
        else: 
            left_up_coord = 'a' + str(left_up_total)

        left_down_total = (8 - leng) - self.pos_num
        
        # left down
        if left_down_total < 0:
            left_down_coord = 'a' + str(self.Y[ - left_down_total -1])
        else:
            left_down_coord = self.X[left_down_total  + 1] + str(1)
        # print left_down_coord

        return [right_up_coord, right_down_coord, left_up_coord, left_down_coord]


# Since Knight Possibilites go Beyond the h and 8 we are using this function to discard cells. 
def filter_results(result):
    X = ['a','b','c','d','e','f','g','h']
    Y = [1,2,3,4,5,6,7,8]
    all_possibiliites = [x+ str(y) for x in X for y in Y]
    return [x for x in result if x in all_possibiliites]

# Knights Position: 
# 1. Find the corner blocks of input cell. 
# 2. Find the Edge (Adjacent Cells) of the Corner Cells
# 3. Remove the cells around the input Cell from Step 2, Resulting in Possible Knight Moves.
def knight_possibilities(corners, all):
    all_poss = ()
    for i in corners:
        try:
            k = Board(i)
            all_poss += tuple(set(k.edge_blocks()) - set(all))
        except:
            pass
    return filter_results(all_poss)


# Alternate Approach 
def knight_program2(pos):
    X = ['a','b','c','d','e','f','g','h']
    Y = [1,2,3,4,5,6,7,8]
    posn = lambda x : x if x <= 8 else 0
    posa = lambda x: x if x in X else None
    k = Board(pos)
    pos_near = filter(lambda x: x > 0, [posn(k.pos_num) + 2 ,posn(k.pos_num) - 2]) 
    pos_far = filter(lambda x: x > 0, [k.pos_num + 1, k.pos_num-1])
    pos_a_near = filter( None, [X[X.index(k.pos_alfa) - 1], X[X.index(k.pos_alfa)+ 1]])
    pos_a_far = filter( None, [X[X.index(k.pos_alfa) - 2], X[X.index(k.pos_alfa) + 2]])
    
    posa_s = [ y +str(x) for x in pos_near for y in pos_a_near] + [y + str(x) for x in pos_far for y in pos_a_far]

    print posa_s

if __name__ == "__main__":
    name = sys.argv[1]
    pos = sys.argv[2]
    print name , pos
    print "*-----------------*"
    
    # knight_program2(pos)
    try:
        given = Board(pos)
        if name.startswith('k'):     
            print "Jumps to", knight_possibilities(given.corner_blocks(), given.all_blocks())
        if name.startswith('r'): 
            print "Vertical", given.veritical_dir()[0], given.veritical_dir()[-1]
            print "Horizontal", given.horizontal_dir()[0], given.horizontal_dir()[-1]
        if name.startswith('q'):
            print "Vertical",  given.veritical_dir()[0], given.veritical_dir()[-1]
            print "Horizontal",given.horizontal_dir()[0], given.horizontal_dir()[-1]
            print "Corners", given.corner_dir()
            
    except Exception, e:
        print e
        print "Something went wrong with your input."


