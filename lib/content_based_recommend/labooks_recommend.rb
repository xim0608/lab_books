module ContentBasedRecommend
  class LabooksRecommend

    def self.set_recommends
      title_separated = separated_words(include_desc = false)
      desc_separated = separated_words(include_desc = true)
      title_matrix = generate_dense_matrix(calculate_tf_idf(title_separated), title_separated)
      description_matrix = generate_dense_matrix(calculate_tf_idf(desc_separated), desc_separated)
      calculate_cosine_similarity(title_matrix, description_matrix)
    end

    private

    def self.separated_words(include_desc = false)
      include Math
      include ContentBasedRecommend
      require 'natto'
      require 'matrix'

      stop_word = []
      stop_word_url = 'http://svn.sourceforge.jp/svnroot/slothlib/CSharp/Version1/SlothLib/NLP/Filter/StopWord/word/Japanese.txt'
      open(stop_word_url) do |f|
        f.each_line do |word|
          stop_word << word.strip if word.present?
        end
      end

      stop_word += ['版']
      stop_word += [*1..10].map(&:to_s)
      p stop_word
      mecab = Natto::MeCab.new
      books = Book.all

      word_list = []

      # tf = ある単語tがある文書に現れる回数 / ある文書中の全ての単語数
      # idf = log(比較する文書の総数N / ある単語が現れた文書数)
      all_count = {}

      books.each do |book|
        if book.description.present? && include_desc
          sentence = book.name + ' ' + book.description
        else
          sentence = book.name
        end

        wakatigaki = []
        mecab.parse(sentence) do |n|
          if n.feature.match(/名詞/)
            # print(n.surface + '  ')
            wakatigaki << n.surface unless stop_word.include?(n.surface)
          end
        end
        word_list.append(wakatigaki)

        word_count = {}
        wakatigaki.each do |word|
          if word_count.has_key?(word)
            all_count[book.id] = word_count[word]
          else
            word_count[word] = 0
            all_count[book.id] = 0
          end
          word_count[word] += 1
        end
        all_count[book.id] = word_count
      end
      p all_count

      count_data = {all_count: all_count, word_list: word_list}
    end

    def self.calculate_tf_idf(count_data)
      raise if count_data.nil?

      tf_store = {}
      sub_tfstore = {}
      merge_idf = {}
      merge_tfidf = {}

      all_count = count_data[:all_count]

      all_count.each do |book_id, keywords|
        sum = 0
        keywords.each do |keyword, keyword_count|
          sum += keyword_count
        end
        sub_tfstore[book_id] = sum
      end

      all_count.each do |book_id, keywords|
        counter = {}
        keywords.each do |keyword, keyword_count|
          counter[keyword] = all_count[book_id][keyword].to_f / sub_tfstore[book_id]
        end
        tf_store[book_id] = counter
      end

      word_count = {}
      all_count.each do |book_id, keywords|
        keywords.each do |keyword, keyword_count|
          unless word_count[keyword].present?
            word_count[keyword] = 1
          else
            word_count[keyword] += 1
          end
        end
      end
      sub_idf = word_count

      all_count.each do |book_id, keywords|
        idf_store = {}
        keywords.each do |keyword, keyword_count|
          idf_store[keyword] = Math.log(all_count.size / sub_idf[keyword].to_f)
        end
        merge_idf[book_id] = idf_store
      end

      all_count.each do |book_id, keywords|
        tfidf = {}
        keywords.each do |keyword, keyword_count|
          tfidf[keyword] = tf_store[book_id][keyword] * merge_idf[book_id][keyword]
        end
        merge_tfidf[book_id] = tfidf
      end

      p merge_tfidf
      merge_tfidf.each do |book_id, keywords|
        print "#{Book.find(book_id).name}: "
        p keywords.sort {|(k1, v1), (k2, v2)| v2 <=> v1}
      end
      merge_tfidf
    end

    def self.generate_dense_matrix(tf_idf, count_data)
      books_tfidf = tf_idf

      uniq_word_list = count_data[:word_list].flatten!.uniq!
      vector = Array.new(count_data[:all_count].keys.last + 1)
      p vector
      # vector[0]は空のベクトル(book_idは1から)
      books_tfidf.each do |book_id, keywords|
        index = []
        value = []
        keywords.each do |keyword, tf_idf|
          uniq_word_list_index = uniq_word_list.index(keyword)
          index << uniq_word_list_index
          value << tf_idf
        end
        vector[book_id] = [index, value]
      end
      vector
    end

    def self.calculate_cosine_similarity(matrix, desc_matrix)
      books = Book.all
      books.each do |book|
        base_vec = matrix[book.id]

        max_score = Array.new(6, {score: 0, index: 0})
        matrix.each_with_index do |vector, index|
          next if vector.nil?
          next if index == 0
          next if index == book.id
          double = vector[0] & base_vec[0]
          score = 0
          double.each do |s|
            score += vector[1][vector[0].index(s)] * base_vec[1][base_vec[0].index(s)]
          end
          score = score.fdiv(Math.sqrt(base_vec[1].reduce(0) {|vec, s| vec += s ** 2} * vector[1].reduce(0) {|vec, s| vec += s ** 2}))
          next if score > 0.98
          max_score.sort! {|a, b| a[:score] <=> b[:score]}
          if max_score[0][:score] < score
            max_score.shift
            max_score.push({score: score, index: index})
          end
        end
        max_score.map! do |score|
          if score[:score] < 0.20
            {score: 0, index: 0}
          else
            score
          end
        end
        p max_score
        if max_score.count({score: 0, index: 0}) > 0
          title_recommend_index = max_score.map {|s| s[:index]}
          desc_matrix.each_with_index do |vector, index|
            next if vector.nil?
            next if index == 0
            next if index == book.id
            next if title_recommend_index.include?(index)
            double = vector[0] & base_vec[0]
            score = 0
            double.each do |s|
              score += vector[1][vector[0].index(s)] * base_vec[1][base_vec[0].index(s)]
            end
            score = score.fdiv(Math.sqrt(base_vec[1].reduce(0) {|vec, s| vec += s ** 2} * vector[1].reduce(0) {|vec, s| vec += s ** 2}))
            max_score.sort! {|a, b| a[:score] <=> b[:score]}
            if max_score[0][:score] < score
              max_score.shift
              max_score.push({score: score, index: index})
            end
          end
        end
        p "===================="

        p "Base: #{book.name}"
        p max_score.size
        max_score.delete({score: 0, index: 0})
        # p max_score
        max_score.each do |score|
          score.each do |k, v|
            if k == :index
              p Book.find(v).name
              p score
            elsif k == :score
              p "score: #{v}"
            end
          end
        end
        p "===================="

        Redis.current.set("books/recommends/#{book.id}", max_score.map {|k| k[:index]})
      end
    end

  end
end

