# frozen_string_literal: true

require_relative "unihan_lang/version"
require_relative "unihan_lang/chinese_processor"
require_relative "unihan_lang/variant_mapping"

module UnihanLang
  class Unihan
    def initialize
      @chinese_processor = ChineseProcessor.new
      @variant_mapping = VariantMapping.new
    end

    def zh_tw?(text)
      language_ratio(text) == :tw
    end

    def zh_cn?(text)
      language_ratio(text) == :cn
    end

    def only_zh_tw?(text)
      text.chars.all? { |char| @chinese_processor.only_zh_tw?(char) }
    end

    def only_zh_cn?(text)
      text.chars.all? { |char| @chinese_processor.only_zh_cn?(char) }
    end

    def contains_zh_tw?(text)
      text.chars.any? { |char| @chinese_processor.only_zh_tw?(char) }
    end

    def contains_zh_cn?(text)
      text.chars.any? { |char| @chinese_processor.only_zh_cn?(char) }
    end

    def contains_chinese?(text)
      text.chars.any? { |char| @chinese_processor.chinese_character?(char) }
    end

    def extract_chinese_characters(text)
      text.chars.select { |char| @chinese_processor.chinese_character?(char) }
    end

    def determine_language(text)
      case language_ratio(text)
      when :tw then "ZH_TW"
      when :cn then "ZH_CN"
      else "Unknown"
      end
    end

    def analyze_with_variants(text)
      chars = text.chars
      traditional_score = 0
      simplified_score = 0

      chars.each do |char|
        if @chinese_processor.chinese_character?(char)
          if @chinese_processor.only_zh_tw?(char)
            traditional_score += 2  # 繁体字の重みを増やす
          elsif @chinese_processor.only_zh_cn?(char)
            simplified_score += 2  # 簡体字の重みを増やす
          end

          # 異体字による判定の重みを調整
          if @variant_mapping.traditional_variants(char).any?
            traditional_score += 0.5
          end
          if @variant_mapping.simplified_variants(char).any?
            simplified_score += 0.5
          end
        end
      end

      {
        traditional_score: traditional_score,
        simplified_score: simplified_score,
        total_chinese: chars.count { |c| @chinese_processor.chinese_character?(c) }
      }
    end

    def determine_language_with_variants(text)
      scores = analyze_with_variants(text)
      return "Unknown" if scores[:total_chinese] == 0

      if scores[:traditional_score] > scores[:simplified_score]
        "ZH_TW"
      elsif scores[:simplified_score] > scores[:traditional_score]
        "ZH_CN"
      else
        "Unknown"
      end
    end

    private

    # テキストの言語比率を計算し、最も可能性の高い言語を返す
    def language_ratio(text)
      scores = analyze_with_variants(text)
      return :unknown if scores[:total_chinese] != text.length
      return :tw if scores[:traditional_score] > scores[:simplified_score]
      return :cn if scores[:simplified_score] >= scores[:traditional_score]
      :unknown
    end
  end
end
