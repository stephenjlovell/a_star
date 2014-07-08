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

  class Edge
    attr_reader :cost, :child

    def initialize(cost, child)
      @cost = cost
      @child = child
    end

    def inspect
      "<E #{@cost}:#{@child.inspect}>"
    end
  end

  class Node
    attr_accessor :g, :h, :parent, :edges, :enabled
    attr_reader :x, :y, :hash

    def initialize(x,y)
      @x = x
      @y = y
      
      @g = 0  # Used to store distance from the starting node to the current node
      # Stores a heuristic estimate of the distance remaining to the goal node.

      @edges = []  # an array of edge structs
      @enabled = true
      @hash = [@x, @y].hash
    end

    def ==(other)
      @hash == other.hash
    end

    def h(goal)
      @h ||= AStar::manhattan_distance(self, goal)
    end

    def f(goal)
      @g + h(goal)
    end

    def inspect
      "<N (#{@x},#{@y})>"
    end
  end

  class Graph # creates a square grid of (width)**2 nodes, each linked to any adjacent nodes.

    def initialize(width)
      @width = width
      @nodes = Array.new(width) {|y| Array.new(width) {|x| Node.new(x,y) } }
      link_nodes
    end

    def each
      @nodes.each_with_index do |row, y| 
        row.each_with_index do |node, x|
          yield(node)
        end
      end
    end

    def to_h
      @nodes.flatten.inject({}) { |hsh, node| hsh[node] = true; hsh }
    end

    def [](x,y)
      @nodes[y][x]
    end

    def []=(x,y,node)
      @nodes[y][x] = node
    end

    def disable(x,y)
      @nodes[y][x].enabled = false
    end

    def enable(x,y)
      @nodes[y][x].enabled = true
    end

    GRAPHICS = { open: "\u00B7", blocked: "\u25a0", start: "\u0391", goal: "\u03A9", pv: "\u0298" }

    def print(start=nil, goal=nil, pv=nil)
      if pv.nil?
        pv = {}
      else
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
    def link_nodes
      each do |node|
        (-1..1).each do |y_offset|
          (-1..1).each do |x_offset|
            y = node.y + y_offset
            x = node.x + x_offset
            if 0 <= x && x < @width && 0 <= y && y < @width && (x_offset != 0 || y_offset != 0)
              other = @nodes[y][x]
              if AStar::manhattan_distance(node, other) == 2
                node.edges << AStar::Edge.new(141, other)
              else
                node.edges << AStar::Edge.new(100, other)
              end
            end
          end
        end
      end
    end

  end

  def self.manhattan_distance(from, to)
    (from.y-to.y).abs + (from.x-to.x).abs
  end

end









