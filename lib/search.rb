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

  def self.retrieve_pv(active, from)
    pv = []
    until active.parent.nil? do
      pv << active
      active = active.parent
    end
    pv
  end

  def self.search(graph, start, goal)
    open = {}
    closed = {}
    active = start

    open.store(start, true)

    until open.empty? do
      active = open.min_by { |node, value| node.f(goal) }.first
      return retrieve_pv(active, start) if active == goal
      
      open.delete(active)
      closed.store(active, true)

      next unless active.enabled

      active.edges.each do |edge|
        child = edge.child
        next if closed[child]

        g = active.g + edge.cost

        if !open[child] || g < child.g
          # If the child node hasn't been tried or if the current path to the child node is shorter than 
          # the previously tried path, save the g value in the child node.
          child.parent = active
          child.g = g
          child.h(goal)
          open.store(child, true) if !open[child] 
        end
      end
    end

    return nil 
  end



end






