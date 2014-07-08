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

module AStar

  def self.retrieve_pv(active, from) # Re-trace our steps from the current node
    pv = []                          # back to the starting node.
    until active.parent.nil? do
      pv << active
      active = active.parent
    end
    pv.reverse!
  end

  def self.search(start, goal)
    open, closed = {}, {}
    active = start
    open.store(start, true) # Add the starting node to the open set.

    until open.empty? do # Keep searching until we reach the goal or run out of reachable nodes. 
      active = open.min_by { |node, value| node.f(goal) }.first # try the most promising nodes first.
      return retrieve_pv(active, start) if active == goal # Stop searching once the goal is reached.
      
      open.delete(active) # Move the active node from the open set to the closed set.
      closed.store(active, true)

      next unless active.enabled # if this node is impassible, ignore it and move on to the next child.

      active.edges.each do |edge|
        child = edge.child
        next if closed[child] # ignore child nodes that have already been expanded.

        g = active.g + edge.cost # get the cost of the current path to this child node.

        # If the child node hasn't been tried or if the current path to the child node is shorter 
        # than the previously tried path, save the g value in the child node.
        if !open[child] || g < child.g 
          child.parent = active  # save a reference to the parent node
          child.g = g
          child.h(goal)
          open.store(child, true) if !open[child] 
        end
      end
    end

    puts "No path from #{start} to #{goal} was found."
    return nil 
  end



end






