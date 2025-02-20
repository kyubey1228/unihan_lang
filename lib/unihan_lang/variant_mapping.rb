# frozen_string_literal: true

module UnihanLang
  class VariantMapping
    def initialize
      @traditional_to_simplified = load_variant_mappings
      @simplified_to_traditional = {}
      # 簡体字から繁体字へのマッピングを構築
      @traditional_to_simplified.each do |trad, simps|
        simps.each do |simp|
          @simplified_to_traditional[simp] ||= Set.new
          @simplified_to_traditional[simp] << trad
        end
      end
    end

    def traditional_variants(char)
      @simplified_to_traditional[char] || Set.new
    end

    def simplified_variants(char)
      @traditional_to_simplified[char] || Set.new
    end

    private

    def load_variant_mappings
      traditional_to_simplified = {}
      file_path = File.join(File.dirname(__FILE__), "..", "..", "data", "Unihan_Variants.txt")

      File.foreach(file_path, encoding: "UTF-8") do |line|
        next if line.start_with?("#") || line.strip.empty?

        fields = line.strip.split("\t")
        # kTraditionalVariant フィールドの場合のみ処理
        if fields.size >= 3 && fields[1] == ("kTraditionalVariant")
          simp = [fields[0].gsub(/^U\+/, "").hex].pack("U")
          trad = [fields[2].gsub(/^U\+/, "").hex].pack("U")
          traditional_to_simplified[trad] ||= Set.new
          traditional_to_simplified[trad] << simp
        end
      end
      traditional_to_simplified
    end
  end
end
