require File.expand_path(__FILE__ + '/../../player')

describe "a player" do
  let (:warrior) { mock('warrior').as_null_object }
  let (:feel) { mock('feel').as_null_object }

  before do 
    warrior.stub :feel => feel
    feel.stub :wall? => false
    feel.stub :enemy? => false
  end

  it "should remember its warrior's last hp" do
    warrior.stub :health => 7 
    player = Player.new

    player.play_turn warrior 

    player.hp.should == 7
  end

  it "should know when there is an archer in front" do
    warrior.stub :health => 10
    player = Player.new
    player.stub :hp => 12

    player.play_turn warrior

    player.should have_archer_present
  end

  it "should know when there is no archer in front" do
    warrior.stub :health => 10
    player = Player.new
    player.stub :hp => 10 

    player.play_turn warrior 

    player.should_not have_archer_present
  end

  it "should start out by proceeding backwards first" do
    player = Player.new

    player.play_turn warrior

    player.direction.should == :backward
  end

  it "should stop going backward when there is a wall" do
    feel.stub :wall? => true
    player = Player.new

    player.play_turn warrior 

    player.direction.should == :forward
  end
end

describe "a warrior" do
  let (:warrior) { mock('warrior').as_null_object }
  let (:feel) { mock('feel').as_null_object }

  before do 
    warrior.stub :feel => feel 
    feel.stub :empty? => false
    feel.stub :captive? => false
    feel.stub :enemy? => false
  end

  context "when there is nothing in the way" do
    before do
      feel.stub :empty? => true
    end

    it "should walk forward when hp is greater than 18" do
      warrior.stub :health => 19
      warrior.should_receive :walk!

      Player.new.play_turn warrior 
    end

    it "should rest when hp is 18 or lower" do
      warrior.stub :health => 6
      warrior.should_receive :rest! 

      Player.new.play_turn warrior 
    end

    it "should walk forward when hp is lower than 18 but the current hp is lower than the last turn's hp" do
      warrior.stub :health => 9
      warrior.should_receive :walk! 

      player = Player.new
      player.stub :hp => 12 
      player.play_turn warrior 
    end

    it "should go backwards when there is a wizard ahead" do

    end
  end

  context "when there is a captive in front" do
    before do
      feel.stub :captive? => true
    end

    it "should rescue" do
      warrior.should_receive :rescue! 

      Player.new.play_turn warrior 
    end
  end

  context "when there is an enemy in the way" do
    before do
      feel.stub :enemy? => true
    end

    it "should attack when hp is greater than 10" do
      warrior.stub :health => 15
      warrior.should_receive :attack! 

      Player.new.play_turn warrior 
    end

    it "should back up when hp is at 10 or lower" do
      warrior.stub :health => 10
      warrior.should_receive(:walk!).with(:backward)

      Player.new.play_turn warrior 
    end

    it "should attack if there is an archer in front, even when hp is low" do
      warrior.stub :health => 6
      player = Player.new
      player.stub :has_archer_present? => true
      warrior.should_receive :attack! 

      player.play_turn warrior 
    end

    it "should turn around if there is an enemy behind" do
      feel.stub(:wall? => false)
      feel.stub(:enemy? => true)
      warrior.should_receive(:pivot!)
      player = Player.new

      player.play_turn warrior
    end
  end
end
