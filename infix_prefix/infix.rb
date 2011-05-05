class String
  def is_number?
    !!self.match(/^\d+$/)
  end
end

class Operator
  include Comparable

  attr_reader :value

  PRESEDENCE = {
      '^'  =>  3,
      '*'  =>  2,
      '/'  =>  2,
      '%'  =>  2,
      '+'  =>  1,
      '-'  =>  1,
      '('  => -1
  }

  def initialize(value)
    @value = value
  end

  def precedence
    PRESEDENCE[value]
  end

  def <=>(other)
   return - 1 if precedence < other.precedence
   return  1  if precedence > other.precedence
   return 0
  end

  def calculate(operand1, operand2)
    if operand1.is_a?(Numeric) and operand2.is_a?(Numeric)
      operand1.send(value, operand2)
    else
      [value, operand1, operand2]
    end
  end

  def to_s
    value
  end
end

class TreeNode
  attr_accessor :root, :left, :right

  def initialize(root)
    @root = root
  end

  def prefix
    if root.is_a?(Operator)
      [root, left.prefix, right.prefix]
    else
      [root]
    end
  end

  def calculate
    if root.is_a?(Operator)
      root.calculate( left.calculate, right.calculate )
    else
      root.is_number? ? root.to_i : root
    end
  end
end

class Infix
  attr_reader :tree, :value

  def initialize(value)
    @value = value
    @tree = create_tree
  end

  def prefix(reduce=false)
    if reduce
      calculation = tree.calculate
      calculation.is_a?(Array) ? calculation.join(' ') : calculation
    else
      tree.prefix.join(' ')
    end
  end

  private

  def create_node(operators,nodes)
    node = TreeNode.new(operators.pop)
    node.right = nodes.pop
    node.left = nodes.pop
    nodes.push(node)
  end

  def create_tree
    tokens = value.split(" ")
    operators, nodes = [], []
    for token in tokens
      case token
        when /[a-zA-Z0-9]/
          nodes.push TreeNode.new(token)
        when /[-\+\/\*\^]/
          operator = Operator.new(token)
          while not(operators.empty? or
                    operators.last.value == '(' or
                    operators.last < operator)
            create_node(operators,nodes)
          end
          operators.push operator
        when '('
          operators.push Operator.new(token)
        when ')'
          while operators.last.value != "("
            create_node(operators,nodes)
          end
          operators.pop
      end
    end

    while operators.any?
     create_node(operators,nodes)
    end
    nodes.last
  end
end


