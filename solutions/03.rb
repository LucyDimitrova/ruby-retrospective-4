#deleting pointless methods and lines in functions
#adding a helper class Parser
#fixing File and Directory parse methods
#fixing identation

class String
  def to_bool
    self == "true"
  end

  def string_conversion(type)
    case type
      when "nil"     then return nil
      when "symbol"  then return self.to_sym
      when "string"  then return self.to_s
      when "boolean" then return self.to_bool
    end
    return self.to_f if type == "number" and self.include? "."
    return self.to_i if type == "number" and !self.include? "."
  end
end

class Hash
  def interpolate
    serialized_objects = self.map do |name, object|
      serialized_object = object.serialize
      "#{name}:#{serialized_object.length}:#{serialized_object}"
    end
    "#{self.count}:#{serialized_objects.join('')}"
  end
end

module RBFS
  class File
    attr_accessor :data

    def initialize(object = nil)
      @data = object
    end

    def data_type
      case @data
        when NilClass              then :nil
        when String                then :string
        when Fixnum, Float         then :number
        when Symbol                then :symbol
        when TrueClass, FalseClass then :boolean
      end
    end

    def serialize
      "#{self.data_type.to_s}:#{@data.to_s}"
    end

    def self.parse(string_data)
      parsed      = File.new
      data_type   = string_data.split(":")[0]
      data        = string_data.match(':(.*)')[1]
      parsed.data = data.string_conversion(data_type)
      parsed
    end
  end

  class Directory
    attr_reader :files, :directories

    def initialize
      @directories = {}
      @files       = {}
    end

    def add_file(name, file)
      if name.include? ":"
        "name cannot contain a colon"
      else @files[name] = file
      end
    end

    def add_directory(name, directory = Directory.new)
      if name.include? ":"
        "name cannot contain a colon"
      else @directories[name] = directory
      end
    end

    def [](name)
      @directories[name] || @files[name]
    end

    def serialize
      "#{@files.interpolate}#{@directories.interpolate}"
    end

    def self.parse(string_data)
      directory = Directory.new
      parser = Parser.new(string_data)
      parser.items_to_parse do |name, data|
        directory.add_file(name, File.parse(data))
      end
      parser.items_to_parse do |name, data|
        directory.add_directory(name, Directory.parse(data))
      end
      directory
    end
  end

  class Parser
    def initialize(string_data)
      @string_data = string_data
    end

    def items_to_parse
      counter, @string_data = @string_data.split(':', 2)
      counter.to_i.times do
        name, length, rest = @string_data.split(':', 3)
        yield name, rest[0...length.to_i]
        @string_data = rest[length.to_i..-1]
      end
    end
  end
end
