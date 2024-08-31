# frozen_string_literal: true

require "natto"

module UnihanLang
  class JapaneseProcessor
    def initialize
      @natto = Natto::MeCab.new
    end

    def is_japanese?(text)
      return true if text.match?(/[\p{Hiragana}\p{Katakana}ー]/)

      tokens = tokenize(text)
      japanese_token_ratio = calculate_japanese_token_ratio(tokens)
      japanese_token_ratio > 0.5
    end

    private

    def tokenize(text)
      @natto.parse(text).split("\n").map do |line|
        next if line.start_with?("#") || line.strip.empty? || line.strip == "EOS"

        surface, feature = line.strip.split(",")
        { surface:, feature: }
      end.compact
    end

    def calculate_japanese_token_ratio(tokens)
      japanese_tokens = tokens.count { |token| japanese_token?(token) }
      japanese_tokens.to_f / tokens.size
    end

    def japanese_token?(token)
      %w(名詞 動詞 形容詞 助詞 助動詞).any? { |pos| token[:feature].start_with?(pos) } ||
        token[:feature].end_with?("接続助詞")
    end
  end
end
