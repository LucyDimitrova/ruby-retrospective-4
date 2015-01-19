module UI

  class TextScreen
    def self.draw (&block)
      result = Label.new
      result.instance_eval(&block)
      result.array.join("") + "\n"
    end
  end

  class Label

    def initialize
      @array = []
    end

    attr_accessor :array

    def label(text:, border: nil, style: nil)
      stylish = lambda {return "#{border}#{text.send(style)}#{border}"}
      not_stylish = lambda {return "#{border}#{text}#{border}"}
      self.array << not_stylish.call if style == nil
      self.array << stylish.call if style != nil
    end

    def vertical(border: nil, style: nil, &block)
      helper = Label.new
      helper.instance_eval(&block)
      if border != nil then helper.array.bordered(border) end
      if style != nil then helper.array.stylize(style) end
      self.array << helper.array.map {|element| element + "\n"}
    end

    def horizontal(border: nil, style: nil, &block)
      helper = Labels.new
      helper.instance_eval(&block)
      if border != nil then helper.array.bordered(border) end
      if style != nil then helper.array.stylize(style) end
      self.array << helper.array
    end

  end
end

class Array
  def longest_word
    group_by(&:size).max.last
  end

  def bordered(sign)
    max = self.longest_word
    self.map {|w| w = "#{sign}#{w.append(max.size - w.size)}#{sign}"}
  end

  def stylize(style)
    self.map {|word| word.send(style)}
  end
end

class String
  def append(number)
    self + " " * number
  end
end