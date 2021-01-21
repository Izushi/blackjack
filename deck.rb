class Deck
  def initialize
    @cards = []

    mk = ["スペード", "ハート", "ダイア", "クラブ"]
    num = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]

    mk.each do |mark|
      num.each do |number|
        card = Card.new(mark, number)
        @cards << card #markとnumber、全ての組み合わせを作り@cardの配列に入れる
      end
    end
    @cards.shuffle! #配列内をシャッフル
  end

  def draw
    @cards.shift #配列内の先頭の要素を取り出すメソッド
  end
end