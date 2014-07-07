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

  def self.manhattan_distance(from, to)
    (from.y-to.y).abs + (from.x-to.x).abs
  end


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
    attr_accessor :g, :h, :parent, :edges
    attr_reader :x, :y

    def initialize(x,y)
      @x = x
      @y = y
      @g = 0
      @h = 0
      @edges = []  # an array of edge structs
    end

    def inspect
      "<N (#{@x},#{@y})>"
    end
  end

  class Graph # creates a square grid of (width)**2 nodes, each linked to any adjacent nodes.
    # include Enumerable

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




end









