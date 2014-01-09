# a simple UNIX configs parser/writter
module Ninefold
  class Config
    def self.read(filename)
      if File.exists?(filename)
        new filename
      end
    end

    attr_reader :filename, :params

    def initialize(filename, params={})
      @filename = filename
      @params   = params
      read
    end

    def [](key)
      @params[key]
    end

    def []=(key, value)
      @params[key] = value
    end

    def read
      hash = @params

      File.exists?(@filename) &&  File.read(@filename).strip.split("\n").each do |line|
        if m = line.strip.match(/\[(.+?)\]/)
          hash = @params[m[1]] = {}
        elsif m = line.strip.match(/(.+?)\s*=\s*(.+)/)
          value = m[2]
          value = value.to_i if value =~ /^[0-9]+$/
          value = value.to_f if value =~ /^[0-9]+\.[0-9]+$/
          value = true       if value == 'true'
          value = false      if value == 'false'
          hash[m[1]] = value
        end
      end
    end

    def write(data)
      File.open(@filename, "w") do |file|
        file.write data.map{ |key, value|
          if value.is_a?(Hash)
            "[#{key}]\n" + value.map { |k, v| "  #{k} = #{v}" }.join("\n")
          else
            "#{key} = #{value}"
          end
        }.join("\n")
      end
    end

    def delete
      File.unlink(@filename) if File.exists?(@filename)
    end
  end
end
