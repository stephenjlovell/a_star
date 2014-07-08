#-----------------------------------------------------------------------------------
# Copyright (c) 2014 Stephen J. Lovell
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#-----------------------------------------------------------------------------------


require './lib/graph.rb'
require './lib/search.rb'

graph = AStar::Graph.new(8) # create an 8x8 Cartesian graph

5.times {|n| graph.disable(5, n) }  # add some obstacles to make things interesting
5.times {|n| graph.disable(2, 7-n) }
graph.disable(4,4)

start = graph[0,3]
goal = graph[7,0]

pv = AStar::search(graph, start, goal) # find the optimal path from start to goal
print pv, "\n"
graph.print(start, goal, pv) # print out the optimal solution






