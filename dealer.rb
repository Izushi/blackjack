class Dealer
  def initialize
    @hands = []
  end

  def hands
    @hands
  end

  def first_draw_dealer(deck) #この仮引数(deck)は任意に決められる。blackjack.rbの実引数(@deck)が重要。
    card = deck.draw #Deckクラスのdrawメソッド
    @hands << card #空の配列@handsに入れる

    puts <<~text

    ------------Dealer手札------------
     1枚目 ： #{card.show}
     2枚目 ： 伏せられている
    ----------------------------------

    text

    card = deck.draw
    @hands << card

    # puts "-------------Dealer手札-------------"
    # @hands.each.with_index(1) do |hand, i| #@hands配列内全てのカードを1から順番に選び
    #   puts "#{i}枚目 : #{hand.show}" #選んだカードをCardクラスのshowメソッドにより出力
    # end
  end

  def draw_dealer(deck) #追加でカードを引く
    card = deck.draw
    @hands << card

    # hands_show_dealer
  end

  def hands_show_dealer
    puts <<~text

    -------------Dealer手札-------------

    text

    @hands.each.with_index(1) do |hand, i|
      puts "#{i}枚目 : #{hand.show}"
    end
  end
end