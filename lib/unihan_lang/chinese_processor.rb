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

    def only_zh_tw?(char)
      @zh_tw.include?(char) && !@common.include?(char)
    end

    def only_zh_cn?(char)
      @zh_cn.include?(char)
    end

    def chinese?(char)
      zh_tw?(char) || zh_cn?(char) || cjk?(char)
    end

    def chinese_character?(char)
      chinese?(char)
    end

    private

    def cjk?(char)
      char.ord >= 0x4E00 && char.ord <= 0x9FFF
    end

    def load_chinese_characters
      load_unihan_variants
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
      from = [fields[0].gsub(/^U\+/, "").hex].pack("U")
      # Remove dictionary name.
      # Example: U+348B kSemanticVariant U+5EDD<kMatthews U+53AE<kMatthews
      to = [fields[2].split("<")[0].gsub(/^U\+/, "").hex].pack("U")
      case fields[1]
      when "kTraditionalVariant"
        @zh_cn << from
        @zh_tw << to
      when "kSimplifiedVariant"
        @zh_tw << from
        @zh_cn << to
      end
    end

    def process_character_sets
      # There are same code point both zh_tw and zh_cn in Unihan_Variants.txt.
      # Example: 台(U+53F0)
      # U+53F0	kSimplifiedVariant	U+53F0
      # U+53F0	kTraditionalVariant	U+53F0 U+6AAF U+81FA U+98B1
      @common = @zh_tw & @zh_cn
      @zh_tw -= @common
      @zh_cn -= @common
    end
  end
end
