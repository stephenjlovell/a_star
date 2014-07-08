# A* Search Algorithm

This project implements the [A* search algorithm](http://en.wikipedia.org/wiki/A*_search_algorithm "Wikipedia: A* Search Algorithm") in Ruby for learning purposes.

## Usage

Create a new graph object:

    graph = AStar::CartesianGraph.new(8) # create an 8x8 Cartesian graph

Add some impassible terrain to the graph to make things interesting:

    5.times {|n| graph.disable(5, n) }  
    5.times {|n| graph.disable(2, 7-n) }
    graph.disable(4,4)

Choose a starting node and a destination node:

    start = graph[0,3]
    goal = graph[7,0]

Search the graph for an optimal path and print it out:

    pv = AStar::search(start, goal) # find the "principal variation", or optimal path from start to goal

    graph.print(start, goal, pv) # print out the optimal solution


Example output:
2.1.0 :001 > load 'initialize.rb'

    [<N (1,2)>, <N (2,2)>, <N (3,3)>, <N (3,4)>, <N (4,5)>, <N (5,5)>, <N (6,4)>, <N (7,3)>, <N (7,2)>, <N (7,1)>, <N (7,0)>]
    |---------------------------------|
    |  ·   ·   ■   ·   ·   ·   ·   ·  |
    |---------------------------------|
    |  ·   ·   ■   ·   ·   ·   ·   ·  |
    |---------------------------------|
    |  ·   ·   ■   ·   ʘ   ʘ   ·   ·  |
    |---------------------------------|
    |  ·   ·   ■   ʘ   ■   ■   ʘ   ·  |
    |---------------------------------|
    |  Α   ·   ■   ʘ   ·   ■   ·   ʘ  |
    |---------------------------------|
    |  ·   ʘ   ʘ   ·   ·   ■   ·   ʘ  |
    |---------------------------------|
    |  ·   ·   ·   ·   ·   ■   ·   ʘ  |
    |---------------------------------|
    |  ·   ·   ·   ·   ·   ■   ·   Ω  |
    |---------------------------------|