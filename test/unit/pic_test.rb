require File.dirname(__FILE__) + '/../test_helper'

class PicTest < ActiveSupport::TestCase
  
  march_madness_fixtures
  
  def test_point_worth
    pic = pics(:cece_george_mason_elite_8)
    ScoringSystems::SYSTEMS.each do |id, system|
      expected = case system.id
      when ScoringSystems::Jared.id
        44
      when ScoringSystems::Espn.id
        80
      when ScoringSystems::Cbs.id
        16
      when ScoringSystems::SportsIllustrated.id
        8
      end
      assert_equal expected, pic.point_worth(system)
    end
  end
  
  def test_furthest_round_won_number
    assert_equal rounds(:championship).number, cece_george_mason_pic(:field_of_64).furthest_round_won_number
    assert_equal rounds(:elite_8).number, cece_george_mason_pic(:field_of_64).master_pic.furthest_round_won_number
  end
  
  def test_master_pic
    pic = cece_george_mason_pic(:field_of_64)
    assert_equal pic.bid_id, pic.master_pic.bid_id
  end
  
  def test_fixtures
    [:field_of_64,
     :field_of_32,
     :sweet_16,
     :elite_8,
     :final_4,
     :championship].each do |round_fixture|
      pic = cece_george_mason_pic round_fixture
      assert_equal teams(:george_mason), pic.bid.team
      assert_equal rounds(round_fixture), pic.game.round
    end
  end
  
  def test_is_correct
    assert cece_george_mason_pic(:elite_8).is_correct?
    assert_not cece_george_mason_pic(:final_4).is_correct?
  end
  
  def test_still_alive
    assert cece_george_mason_pic(:elite_8).still_alive?
    assert_not cece_george_mason_pic(:final_4).still_alive?
  end
  
  def cece_george_mason_pic(round_fixture)
    pics("cece_george_mason_#{round_fixture}".intern)
  end
  
end
