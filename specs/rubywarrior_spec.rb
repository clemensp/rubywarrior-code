require File.expand_path(__FILE__ + '/../../player')

describe "a player" do
  it "should remember its warrior's last hp" do
    warrior = mock('warrior').as_null_object
    warrior.stub(:health => 7)

    player = Player.new
    player.play_turn(warrior)

    player.hp.should == 7
  end
end

describe "a warrior" do
  let (:warrior) { mock('warrior').as_null_object }

  context "when there is nothing in the way" do
    before do
      warrior.stub_chain(:feel, :empty?).and_return(true)
    end

    it "should walk forward when hp is greater than 18" do
      warrior.stub :health => 19
      warrior.should_receive(:walk!)

      Player.new.play_turn(warrior)
    end

    it "should rest when hp is 18 or lower" do
      warrior.stub :health => 6
      warrior.should_receive(:rest!)

      Player.new.play_turn(warrior)
    end

    it "should walk forward when hp is lower than 18 but the current hp is lower than the last turn's hp" do
      warrior.stub :health => 9
      warrior.should_receive(:walk!)

      player = Player.new
      player.stub(:hp => 12)
      player.play_turn(warrior)
    end

    # it "should back up when hp is 18 or lower and the current hp is lower than the last turn's hp" do
    #   warrior.stub :health => 9
    #   warrior.should_receive(:walk!).with(:backward)

    #   player = Player.new
    #   player.stub(:hp => 12)
    #   player.play_turn(warrior)
    # end
  end

  context "when there is something in the way" do
    before do
      warrior.stub_chain(:feel, :empty?).and_return(false)
    end

    it "should attack when hp is greater than 10" do
      warrior.stub :health => 15
      warrior.should_receive(:attack!)

      Player.new.play_turn(warrior)
    end

    it "should back up when hp is at 10 or lower" do
      warrior.stub :health => 10
      warrior.should_receive(:walk!).with(:backward)

      Player.new.play_turn(warrior)
    end
  end
end
