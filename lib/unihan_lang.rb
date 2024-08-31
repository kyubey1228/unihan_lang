# frozen_string_literal: true

require_relative "unihan_lang/version"
require_relative "unihan_lang/japanese_processor"
require_relative "unihan_lang/chinese_processor"

module UnihanLang
  class Unihan
    def initialize
      @chinese_processor = ChineseProcessor.new
      @japanese_processor = JapaneseProcessor.new
    end

    def ja?(text)
      @japanese_processor.is_japanese?(text)
    end

    def zh_tw?(text)
      language_ratio(text) == :tw
    end

    def zh_cn?(text)
      language_ratio(text) == :cn
    end

    def contains_chinese?(text)
      text.chars.any? { |char| @chinese_processor.chinese_character?(char) }
    end

    def extract_chinese_characters(text)
      text.chars.select { |char| @chinese_processor.chinese_character?(char) }
    end

    def determine_language(text)
      case language_ratio(text)
      when :ja then "JA"
      when :tw then "ZH_TW"
      when :cn then "ZH_CN"
      else "Unknown"
      end
    end

    private

    # テキストの言語比率を計算し、最も可能性の高い言語を返す
    def language_ratio(text)
      return :ja if ja?(text)

      tw_chars = text.chars.count { |char| @chinese_processor.zh_tw?(char) }
      cn_chars = text.chars.count { |char| @chinese_processor.zh_cn?(char) }
      chinese_chars = text.chars.count { |char| @chinese_processor.is_chinese?(char) }

      return unless chinese_chars == text.length
      return :tw if tw_chars > cn_chars
      return :cn if cn_chars >= tw_chars

      :unknown
    end
  end
end
