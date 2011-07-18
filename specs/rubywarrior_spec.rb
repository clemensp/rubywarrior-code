require File.expand_path(__FILE__ + '/../../player')

describe "a warrior" do
  let (:warrior) { mock('warrior').as_null_object }

  it "should walk forward when there is nothing in the way" do
    warrior.stub_chain(:feel, :empty?).and_return(true)

    warrior.should_receive(:walk!)

    Player.new.play_turn(warrior)
  end

  context "when there is something in the way" do
    before do
      warrior.stub_chain(:feel, :empty?).and_return(false)
    end

    it "should attack when hp is greater than 5" do
      warrior.stub :health => 10

      warrior.should_receive(:attack!)

      Player.new.play_turn(warrior)
    end

    it "should back up when hp is at 5 or lower" do
      warrior.stub :health => 5

      warrior.should_receive(:walk!).with(:backward)

      Player.new.play_turn(warrior)
    end
  end
end
