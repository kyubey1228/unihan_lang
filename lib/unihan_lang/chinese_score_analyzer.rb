# frozen_string_literal: true

module UnihanLang
  class ChineseScoreAnalyzer
    attr_reader :traditional_score, :simplified_score, :total_chinese

    def initialize(text, chinese_processor, variant_mapping)
      @text = text
      @chinese_processor = chinese_processor
      @variant_mapping = variant_mapping
      @traditional_score = 0
      @simplified_score = 0
      analyze
    end

    def dominant_language
      return "Unknown" if total_chinese.zero?
      return "ZH_TW" if traditional_score > simplified_score
      return "ZH_CN" if simplified_score > traditional_score

      "Unknown"
    end

    def language_ratio
      return :unknown if total_chinese != @text.length
      return :tw if traditional_score > simplified_score
      return :cn if simplified_score >= traditional_score

      :unknown
    end

    private

    def analyze
      @total_chinese = 0
      @text.chars.each do |char|
        next unless @chinese_processor.chinese_character?(char)

        @total_chinese += 1

        calculate_character_scores(char)
      end
    end

    def calculate_character_scores(char)
      if @chinese_processor.only_zh_tw?(char)
        @traditional_score += 2
      elsif @chinese_processor.only_zh_cn?(char)
        @simplified_score += 2
      end

      @traditional_score += 0.5 if @variant_mapping.traditional_variants(char).any?
      @simplified_score += 0.5 if @variant_mapping.simplified_variants(char).any?
    end
  end
end
