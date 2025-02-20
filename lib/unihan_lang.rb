# frozen_string_literal: true

require_relative "unihan_lang/version"
require_relative "unihan_lang/chinese_processor"
require_relative "unihan_lang/variant_mapping"
require_relative "unihan_lang/chinese_score_analyzer"

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
      when :tw then "zh_TW"
      when :cn then "zh_CN"
      else "Unknown"
      end
    end

    def analyze_with_variants(text)
      analyzer = ChineseScoreAnalyzer.new(text, @chinese_processor, @variant_mapping)
      {
        traditional_score: analyzer.traditional_score,
        simplified_score: analyzer.simplified_score,
        total_chinese: analyzer.total_chinese,
      }
    end

    def determine_language_with_variants(text)
      analyzer = ChineseScoreAnalyzer.new(text, @chinese_processor, @variant_mapping)
      analyzer.dominant_language
    end

    private

    def language_ratio(text)
      analyzer = ChineseScoreAnalyzer.new(text, @chinese_processor, @variant_mapping)
      analyzer.language_ratio
    end
  end
end
