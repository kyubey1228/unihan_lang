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
      @contains_kana = false
      analyze
    end

    def dominant_language
      return "Unknown" if contains_kana?
      return "Unknown" if total_chinese.zero?
      return "ZH_TW" if traditional_score > simplified_score
      return "ZH_CN" if simplified_score > traditional_score

      "Unknown"
    end

    def language_ratio
      return :unknown if contains_kana?
      return :unknown if total_chinese.zero? || total_chinese != meaningful_length
      return :tw if traditional_score > simplified_score
      return :cn if simplified_score > traditional_score

      :unknown
    end

    private

    def contains_kana?
      @contains_kana
    end

    def kana_char?(char)
      ord = char.ord
      # 0x3040-0x309F: ひらがな, 0x30A0-0x30FF: カタカナ, 0x31F0-0x31FF: カタカナ拡張
      (ord >= 0x3040 && ord <= 0x309F) || (ord >= 0x30A0 && ord <= 0x30FF) || (ord >= 0x31F0 && ord <= 0x31FF)
    end

    # Punctuation, digits, and whitespace are ignored so they don't
    # invalidate an otherwise all-Chinese sentence (e.g. "這是中文。").
    def meaningful_length
      @text.chars.count { |char| char.match?(/\p{L}/) }
    end

    def analyze
      @total_chinese = 0
      @text.chars.each do |char|
        @contains_kana ||= kana_char?(char)

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
