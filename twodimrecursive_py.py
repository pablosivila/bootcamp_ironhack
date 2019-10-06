def twodimrecursive(mat, verbose=True):
    
    import logging
    if verbose:
        logging.getLogger().setLevel(logging.DEBUG)
    else:
        logging.getLogger().setLevel(logging.INFO)
        
    
    def depth(mat):        
        checks = []
        depths = []
        logging.debug(f'Entering {mat}')
        # checks will contain each mat's element type
        # It will represent the 'end condition' for the recursion.
        # When it is the case that it doesn't have any more lists. Then we'll stop.
        for item in mat:
            checks.append(type(item) == list)
        
        logging.debug('Checking if subitems are lists')
        logging.debug(checks)
        
        # First, the 'end condition':
        if not any(checks):
            logging.debug('This item is not a list anymore. End recursion.')            
            return 1 # the depth of a non-list item
        
        else: 
            # if you have remaining lists:
            # start by filtering the ones you have.
            filtered_lists = list(filter(lambda x: type(x) == list, 
                                         mat))
            
            logging.debug(f'Filtered Out: {tuple(filter(lambda x: type(x) != list, mat))}')
            logging.debug(f'Lists remaining: {tuple(filter(lambda x: type(x) == list, mat))}')
            
            for item in filtered_lists:
                # calculate the max_depth of that list:
                #logging.debug(f'Entering {item}')
                depths.append(depth(item))
                
            max_depth = max(depths)
            logging.debug(f'Accumulating max depth: {max_depth}')
            # this could have been written as max_depth = max[depth(item) for item in filtered_lists]
            
            # accumulate the depth obtained
            return 1 + max_depth
                    
    return depth(mat)

print(twodimrecursive([[1,2], [1,2,3], [1,[2,[3]]], [2,[[2,[[[3,[5,7]]],[4,5]]],]]]))