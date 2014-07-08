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

  Edge = Struct.new(:cost, :child)

  class CartesianNode
    attr_accessor :g, :h, :parent, :edges, :enabled
    attr_reader :x, :y, :hash # once initialized, the location of the node is immutable.

    def initialize(x,y)
      @x, @y = x, y # Stores the Cartesian coordinates for this node.
      @g = 0  # Stores distance from the starting node to the current node
      @edges = []  # An array of edge structs storing references to any adjacent nodes.
      @enabled = true  # If set to false, this node is 'impassible' and cannot be traversed.
      
      @hash = [@x, @y].hash # create a hash value used when storing the node as a hash key.
    end

    def ==(other)
      @hash == other.hash
    end

    def h(goal) # Stores a heuristic estimate of the distance remaining to the goal node.
      @h ||= AStar::manhattan_distance(self, goal)
    end

    def f(goal)    # Estimates the value of the current path being taken based on the actual distance
      @g + h(goal) # to this node from the start and the estimated distance remaining to the goal.
    end

    def inspect
      "<N (#{@x},#{@y})>"
    end
  end

  class CartesianGraph # Creates an interconnected Cartesian graph of (width)**2 nodes. 

    def initialize(width) # Each node is linked to all adjacent nodes at initialization.
      @width = width
      @nodes = Array.new(width) {|y| Array.new(width) {|x| CartesianNode.new(x,y) } }
      link_nodes
    end

    def each # iterate over all nodes in the graph.
      @nodes.each_with_index do |row, y| 
        row.each_with_index do |node, x|
          yield(node)
        end
      end
    end

    def to_h
      @nodes.flatten.inject({}) { |hsh, node| hsh[node] = true; hsh }
    end

    def [](x,y) # Get a node by its Cartesian coordinates.
      @nodes[y][x]
    end

    def disable(x,y) # Disable the node at the given coordinates.
      @nodes[y][x].enabled = false
    end

    def enable(x,y)  # Enable the node at the given coordinates.
      @nodes[y][x].enabled = true
    end

    GRAPHICS = { open: "\u00B7", blocked: "\u25a0", start: "\u0391", goal: "\u03A9", pv: "\u0298" }

    def print(start=nil, goal=nil, pv=nil) # Prints out the graph along with the path taken from the
      if pv.nil? || pv.empty?              # start node to the goal, if given.
        pv = {}
      else
        puts "\n"
        p pv # Print out the path taken to the goal
        pv = pv.inject({}){|hsh, node| hsh[node] = true; hsh }
      end
      puts separator = "|--" + "-"*(4*@width-3) + "--|"
      @nodes.reverse.each do |row|
        line = "|  " + row.map do |node|
          if !node.enabled 
            GRAPHICS[:blocked]
          elsif node == start
            GRAPHICS[:start]
          elsif node == goal
            GRAPHICS[:goal]
          elsif pv[node]
            GRAPHICS[:pv]
          else
            GRAPHICS[:open]
          end
        end.join("   ") + "  |"
        puts line, separator
      end
    end

    private
    def link_nodes    # Iterates over all nodes in the graph, adding a reference to each adjacent node
      each do |node|  # along with a movement cost representing the distance between the nodes.
        (-1..1).each do |y_offset|
          (-1..1).each do |x_offset|
            y = node.y + y_offset
            x = node.x + x_offset
            if 0 <= x && x < @width && 0 <= y && y < @width && (x_offset != 0 || y_offset != 0)
              other = @nodes[y][x]
              node.edges << Edge.new(AStar::distance(node, other), other)
            end
          end
        end
      end
    end

  end

  def self.manhattan_distance(from, to)   # Returns the movement cost of going directly from one
    (from.y-to.y).abs + (from.x-to.x).abs # node to another without allowing diagonal movement.
  end

  def self.distance(from, to)  # Returns the actual straight-line distance between the two nodes.
    (((from.y-to.y).abs)**2 + ((from.x-to.x).abs)**2)**(1/2.0)
  end

end









