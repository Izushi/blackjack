require "./deck"
require "./card"
require "./player"
require "./dealer" #それぞれのクラスの読み込み
require "./message"

#@変数(インスタンス変数)はクラス内の全メソッドで共通して使用できる
#ローカル変数はそのメソッド内でのみ使用可能

class Blackjack

  include Message #Messageモジュールの読み込み

  BUST_NUMBER = 22 #バーストする

  BLACK_JACK = 21 #ブラックジャックの数字

  RATE = 1.5 #ブラックジャックの際は支払いが1.5倍

  DEALER_DRAW_NUMBER = 16 #dealerは17以上になるまで引き続けるように設定

  def start

    start_message #Message
    
    while true #なぜwhileの繰り返し処理なのか
      build_player
      build_deck
      build_dealer #メソッドの呼び出し

      @count_11 = 0 #変数の初期化
      # @count_11_dealer = 0

      @player_bust_flag = 0
      @dealer_bust_flag = 0

      disp_money(@player) #Message

      request_bet(@player) #request_betメソッドの呼び出し

      information1 #Message

      @dealer.first_draw_dealer(@deck) #build_dealerメソッドから作成された@dealer #Dealerクラス内のfirst_draw_dealerメソッド #引数@deckはbuild_deckメソッドより作成されたもの
      @dealer_point = point_dealer #point_dealerメソッドを@dealer_pointに代入
      @player.first_draw_player(@deck) #build_playerメソッドから作成された@player
      @player_point = point_player #point_playerだけで出力できるのに、なぜ@player_pointに代入するのか => 今後他のメソッド内で使うため？

      if @count_11 == 0 #Aが出たが、player_pointが11以上の時(player_point+1)
        
        player_point_information1 #Message

      else #Aが出て、player_pointが10以下の時(player_point+11)
        
        player_point_information2 #Message

      end

      while true 
        
       information2 #Message

        action = gets.chomp.to_i

        if action == 1
          @player.draw_player(@deck) #なぜ最初の2枚が引かれた状態の@deckから始まるのか => 上から順に処理されるから？
          @player_point = point_player
          
          if @count_11 == 0
            
            player_point_information1 #Message

          else
            
            player_point_information2 #Message

          end

          bust_check #メソッドの呼び出し
          if @player_bust_flag == 1 #@player_point >= BUST_NUMBERの時
            
            information13 #Message

            break
          end

        elsif action == 2
          break

        else
          information3 #Message
        end
      end

      if @player_bust_flag == 0 #playerがカードを引き終わったタイミングかつバーストしてない場合、dealerもカードを引く
        while @dealer_point <= DEALER_DRAW_NUMBER #@dealer_pointが16以下のうちはカードを引き続ける
          @dealer.draw_dealer(@deck)
          @dealer_point = point_dealer

          bust_check #ポイントが22以上かどうかのチェック

        end

        information4

        judge #judgeメソッドの呼び出し

      end

      if @player.money <= 0 #所持金が0円になったらゲームオーバー
        end_message #Message
        break

      else #所持金が1円以上の時
        continue_or_end_message #Message

        continue = gets.chomp.to_i
        if continue == 1 #ゲームを続ける 
          # => なぜwhileから繰り返されるのか、whileから繰り返されるとすれば、disp_money(@player)はなぜ続きの所持金から始まるのか
          information5 #Message

        elsif continue == 2
          information6 #Message
          break

        else
          information7 #Message
        end
      end
    end
  end

  def bust_check
    if @player_point >= BUST_NUMBER
      @player_bust_flag = 1
    elsif @dealer_point >= BUST_NUMBER
      @dealer_bust_flag = 1
    end
  end

  def judge
    @dealer.hands_show_dealer #dealerの手札を公開。Dealerクラスのhands_show_dealerメソッド
    @dealer_point = point_dealer #dealerの合計点数を公開

    dealer_point_information1 #Message

    @player.hands_show_player
    @player_point = point_player

    player_point_information4 #Message

    if @dealer_point == @player_point
      
      information8 #Message
      @money_show = @player.paid_money(@bet) #Messageクラスで使うため@money_showに代入 
      # => Playerクラスのpaid_money 引き分けは掛け金(@bet)分払い戻し

    elsif @player_point == BLACK_JACK
      
      information9
      @paid = @bet + @bet*RATE
      @money_show = @player.paid_money(@paid.floor) #floorは少数を整数に
      # => ブラックジャックは掛け金＊1.5倍支払い
      money_information1 #Message

    elsif @dealer_bust_flag == 1

      information10
      @paid = @bet + @bet
      @money_show = @player.paid_money(@paid)
      # => 勝利の際は掛け金＊1倍支払い
      money_information1 #Message

    elsif @dealer_point > @player_point

      information11

    else
      
      information12
      @paid = @bet + @bet
      @money_show = @player.paid_money(@paid)
      # => 勝利の際は掛け金＊1倍支払い
      money_information1 #Message

    end
  end

  private
    def build_player
      @player = Player.new
    end

    def build_deck
      @deck = Deck.new
    end

    def build_dealer
      @dealer = Dealer.new
    end

    def point_player
      player_point = 0 #呼び出されるたび初期化する
      count_a = 0

      @player.hands.each do |hand| #@player.handsの中には2枚+n回枚のcardが存在する
        player_point += point(hand) #初期化したplayer_pointにcardの枚数回分、pointを足していく

        if point(hand) == 0 #cardがAの時
          count_a += 1 #count_aに1ずつ足す
        end
      end
      
      count_a.times do |i| #count_a回数分do~end内の処理を行う
        if player_point <= 10
          player_point += 11 #player_pointが10以下の時、11足す
          @count_11 = 1
        else
          player_point += 1 #player_pointが11以上の時、1足す
          @count_11 = 0
        end
      end
      return player_point
    end

    def point_dealer
      dealer_point = 0
      count_a =0
      
      @dealer.hands.each do |hand|
        dealer_point += point(hand)
        if point(hand) == 0
          count_a += 1
        end
      end

      count_a.times do |i|
        if dealer_point <= 10
          dealer_point += 11
          @count_11_dealer = 1
        else
          dealer_point += 1
          @count_11_dealer = 0
        end
      end

      # puts "Dealerの得点は#{dealer_point}点です。" 最後まで手札を隠すため、消す。
      dealer_point
    end

    def point(card) #多分Cardクラスのcard -> 否。メソッド名()内は、仮引数だと思うので任意。重要なのはpointを使う際の実引数。
      if card.number == "J" || card.number == "Q" || card.number == "K"
        return number = 10
      elsif card.number == "A"
        return number = 0
      else
        return card.number.to_i
      end
    end

    def request_bet(player)
      while true
        @bet = gets.chomp.to_i
        if @bet.between?(1, player.money)
          @money_show = player.bet_money(@bet) #Playerクラスのbet_moneyメソッド 所持金-掛け金 = 残金
          money_information4 #Message
          break
        else
          information14 #Message
        end
      end
    end
end