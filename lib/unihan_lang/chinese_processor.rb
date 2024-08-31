# frozen_string_literal: true

module UnihanLang
  class ChineseProcessor
    attr_reader :zh_tw, :zh_cn, :common

    def initialize
      @zh_tw = Set.new
      @zh_cn = Set.new
      @common = Set.new
      load_chinese_characters
    end

    def zh_tw?(char)
      @zh_tw.include?(char) || @common.include?(char)
    end

    def zh_cn?(char)
      @zh_cn.include?(char) || @common.include?(char)
    end

    def is_chinese?(char)
      zh_tw?(char) || zh_cn?(char) || is_cjk?(char)
    end

    def chinese_character?(char)
      is_chinese?(char)
    end

    private

    def is_cjk?(char)
      char.ord >= 0x4E00 && char.ord <= 0x9FFF
    end

    def load_chinese_characters
      load_unihan_variants
      load_traditional_chinese_list
      process_character_sets
    end

    def load_unihan_variants
      file_path = File.join(File.dirname(__FILE__), "..", "..", "data", "Unihan_Variants.txt")
      File.foreach(file_path, encoding: "UTF-8") do |line|
        next if line.start_with?("#") || line.strip.empty?

        fields = line.strip.split("\t")
        process_unihan_fields(fields) if fields.size >= 3
      end
    end

    def process_unihan_fields(fields)
      char = [fields[0].gsub(/^U\+/, "").hex].pack("U")
      variant = [fields[2].split("<")[0].gsub(/^U\+/, "").hex].pack("U")
      case fields[1]
      when "kTraditionalVariant"
        @zh_tw << variant
        @zh_cn << char
      when "kSimplifiedVariant"
        @zh_cn << variant
        @zh_tw << char
      end
    end

    def load_traditional_chinese_list
      file_path = File.join(File.dirname(__FILE__), "..", "..", "data",
                            "traditional_chinese_list.txt")
      File.foreach(file_path, encoding: "UTF-8") { |line| @zh_tw << line.strip }
    end

    def process_character_sets
      @common = @zh_tw & @zh_cn
      @zh_tw -= @zh_cn
      @zh_cn -= @zh_tw
      @zh_cn |= @common
    end
  end
end
