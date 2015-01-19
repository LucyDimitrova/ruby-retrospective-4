class String

  def to_bool
    case self
      when "true"  then true
      when "false" then false
    end
  end

  def string_conversion(type)
    case type
      when "nil"     then return nil
      when "symbol"  then return self.to_sym
      when "string"  then return self
      when "boolean" then return self.to_bool
    end
    return self.to_f if type == "number" and self.include? "."
    return self.to_i if type == "number" and !self.include? "."
  end
end

module RBFS

  class File

    def initialize(object = nil)
      @data = object
      @data_type = case @data
                     when NilClass              then :nil
                     when String                then :string
                     when Fixnum, Float         then :number
                     when Symbol                then :symbol
                     when TrueClass, FalseClass then :boolean
                   end
    end

    attr_reader :data_type

    attr_accessor :data

    def serialize
      "#{self.data_type.to_s}:#{@data.to_s}"
    end

    def self.parse(string_data)
      parsed = File.new
      data_type = string_data.split(":")[0]
      data = string_data.split(":")[1].to_s
      parsed.data = data.string_conversion(data_type)
      parsed
    end
  end

  class Directory

    def initialize
      @directory = {}
    end

    attr_reader :files, :directories

    def add_file(name, file)
      if name.include? ":"
        "name cannot contain a colon"
      else @directory[name] = file
      end
      @files = @directory.select {|key, object| object.class == File}
    end

    def add_directory(name, directory = {})
      if name.include? ":"
        "name cannot contain a colon"
      elsif directory == {}
        @directory[name] = Directory.new
      else @directory[name] = directory
      end
      @directories = @directory.select{|key, object| object.class == Directory}
    end

    def [](name)
      matches = @directory.select{|key, hash| key == name}
      matching_dirs = matches.select{|key, hash| hash[key].class == Directory}
      case matches.length
        when 0 then nil
        when 1 then matches[name]
        else matching_dirs[name]
      end
    end
  end
end
