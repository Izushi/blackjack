class Card
  def initialize(mark, number)
    @mark = mark
    @number = number
  end

  def number
    @number
  end

  def show
    return "#{@mark}の#{@number}"
  end
end