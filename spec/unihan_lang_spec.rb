# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UnihanLang::Unihan do
  let(:unihan) { UnihanLang::Unihan.new }

  describe '#zh_tw?' do
    it '繁体字中国語の文字に対してtrueを返す' do
      expect(unihan.zh_tw?('繁體中文')).to be true
    end

    it '簡体字中国語の文字に対してfalseを返す' do
      expect(unihan.zh_tw?('简体中文')).to be false
    end
  end

  describe '#zh_cn?' do
    it '簡体字中国語の文字に対してtrueを返す' do
      expect(unihan.zh_cn?('简体中文')).to be true
    end

    it '繁体字中国語の文字に対してfalseを返す' do
      expect(unihan.zh_cn?('繁體中文')).to be false
    end
  end

  describe '#contains_chinese?' do
    it '中国語の文字を含むテキストに対してtrueを返す' do
      expect(unihan.contains_chinese?('This text contains 中文')).to be true
    end

    it '中国語の文字を含まないテキストに対してfalseを返す' do
      expect(unihan.contains_chinese?('This text does not contain Chinese')).to be false
    end
  end

  describe '#extract_chinese_characters' do
    it '混合テキストから中国語の文字を抽出する' do
      expect(unihan.extract_chinese_characters('This text contains 中文')).to eq(%w[中 文])
    end

    it '中国語の文字を含まないテキストに対して空の配列を返す' do
      expect(unihan.extract_chinese_characters('This text does not contain Chinese')).to be_empty
    end
  end

  describe '#determine_language' do
    it '繁体字中国語を正しく識別する' do
      expect(unihan.determine_language('這是繁體中文')).to eq('ZH_TW')
    end

    it '簡体字中国語を正しく識別する' do
      expect(unihan.determine_language('这是简体中文')).to eq('ZH_CN')
    end

    it '中国語や日本語を含まないテキストに対して"Unknown"を返す' do
      expect(unihan.determine_language('This is English')).to eq('Unknown')
    end
  end

  describe '#only_zh_tw?' do
    it '繁体字のみで構成されたテキストに対してtrueを返す' do
      # U+9AD4	kSimplifiedVariant	U+4F53
      expect(unihan.only_zh_tw?('體')).to be true
    end

    it '簡体字を含むテキストに対してfalseを返す' do
      expect(unihan.only_zh_tw?('繁體简体')).to be false
    end

    it '共通の字を含むテキストに対してfalseを返す' do
      expect(unihan.only_zh_tw?('繁體中文')).to be false
    end

    it 'same codes point both zh_tw and zh_cn in Unihan_Variants.txt returns false' do
      # U+53F0	kSimplifiedVariant	U+53F0
      # U+53F0	kTraditionalVariant	U+53F0 U+6AAF U+81FA U+98B1
      expect(unihan.only_zh_tw?('台')).to be false
    end
  end

  describe '#only_zh_cn?' do
    it '簡体字のみで構成されたテキストに対してtrueを返す' do
      # U+3437	kTraditionalVariant	U+508C
      expect(unihan.only_zh_cn?('㐷')).to be true
    end

    it '繁体字を含むテキストに対してfalseを返す' do
      expect(unihan.only_zh_cn?('简体繁體')).to be false
    end

    it '共通の字を含むテキストに対してfalseを返す' do
      expect(unihan.only_zh_cn?('简体中文')).to be false
    end

    it 'same code points both zh_tw and zh_cn in Unihan_Variants.txt returns false' do
      # U+53F0	kSimplifiedVariant	U+53F0
      # U+53F0	kTraditionalVariant	U+53F0 U+6AAF U+81FA U+98B1
      expect(unihan.only_zh_cn?('台')).to be false
    end
  end

  describe '#contains_zh_tw?' do
    it '繁体字を含むテキストに対してtrueを返す' do
      expect(unihan.contains_zh_tw?('這個text包含繁體字')).to be true
    end

    it '繁体字を含まないテキストに対してfalseを返す' do
      expect(unihan.contains_zh_tw?('这个text不包含简体字')).to be false
    end

    it '共通の漢字のみを含むテキストに対してfalseを返す' do
      expect(unihan.contains_zh_tw?('中文')).to be false
    end
  end

  describe '#contains_zh_cn?' do
    it '簡体字を含むテキストに対してtrueを返す' do
      expect(unihan.contains_zh_cn?('这个text包含简体字')).to be true
    end

    it '簡体字を含まないテキストに対してfalseを返す' do
      expect(unihan.contains_zh_cn?('這個text不包含簡體字')).to be false
    end
  end

  describe '#determine_language_with_variants' do
    context '繁体字の判定精度確認' do
      it '標準的な繁体字のケース' do
        expect(unihan.determine_language_with_variants('這是繁體中文的測試')).to eq('ZH_TW')
      end

      it '異体字を含む繁体字のケース' do
        # 個別の漢字に対する異体字の例
        # 発 -> 發, 様 -> 樣, 国 -> 國
        expect(unihan.determine_language_with_variants('發展樣式國家')).to eq('ZH_TW')
      end

      it '繁体字に特有の表現を含むケース' do
        # 裡 (裏), 儘 (尽), 甚麼 (什么) など
        expect(unihan.determine_language_with_variants('他在裡面做甚麼')).to eq('ZH_TW')
      end

      it '繁体字と簡体字が混在するが、繁体字が優勢なケース' do
        # 台/臺 (どちらでも使用), 机/機 (混在)
        expect(unihan.determine_language_with_variants('在台北的機場裡')).to eq('ZH_TW')
      end
    end

    context '共通漢字と特殊ケース' do
      it '共通漢字が多い場合でも繁体字の特徴を正しく判定' do
        # 中、日、月などの共通漢字が多い文章
        expect(unihan.determine_language_with_variants('今天的月亮很圓')).to eq('ZH_TW')
      end

      it '数字や記号が混ざっている場合' do
        expect(unihan.determine_language_with_variants('2024年的第一個目標：學習繁體字')).to eq('ZH_TW')
      end

      it '地名や固有名詞を含むケース' do
        expect(unihan.determine_language_with_variants('在臺灣學習中文')).to eq('ZH_TW')
      end
    end

    context '頻出パターンの検証' do
      it '教育関連の文章' do
        expect(unihan.determine_language_with_variants('學生們正在學習數學課程')).to eq('ZH_TW')
      end

      it 'ビジネス用語を含む文章' do
        expect(unihan.determine_language_with_variants('公司經營與發展策略')).to eq('ZH_TW')
      end

      it '日常会話の文章' do
        expect(unihan.determine_language_with_variants('我們今天要去買東西')).to eq('ZH_TW')
      end
    end

    context 'エッジケース' do
      it '極めて短い文章でも正確に判定' do
        expect(unihan.determine_language_with_variants('臺')).to eq('ZH_TW')
      end
    end
  end
end
