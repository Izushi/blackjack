class Player

  @@money = 100000 #クラス変数を定義

  def initialize #newメソッドでインスタンスを生成するときに、同時に呼ばれる
    @hands = []
  end

  def money #クラス変数にゲッターを定義
    @@money
  end

  def hands
    @hands
  end

  def count_11
    @count_11
  end

  def bet_money(money)
    @@money -= money
  end

  def first_draw_player(deck)
    card = deck.draw
    @hands << card
    card = deck.draw
    @hands << card #この時点で@handsには2枚のcardが存在する
  
    puts "-------------Player手札-------------"
    @hands.each.with_index(1) do |hand, i| #@hands配列内全てのカードを1から順番に選び
      puts "#{i}枚目 : #{hand.show}" #選んだカードをCardクラスのshowメソッドにより出力
    end
  end

  def draw_player(deck)
    card = deck.draw
    @hands << card #first_draw_playerで決まった@handsに新しいcardを追加
    hands_show_player
  end

  def hands_show_player
    puts <<~text

    -------------Player手札-------------

    text
    @hands.each.with_index(1) do |hand, i|
      puts "#{i}枚目 : #{hand.show}"
    end
  end

  def paid_money(money)
    @@money += money
  end
end