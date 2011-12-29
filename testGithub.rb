require "new_github.rb"
require "test/unit"


class TestGithub < Test::Unit::TestCase

  def test_simple
    #test code for check how much commit on given true date
    assert_equal(1, Github.new("https://api.github.com/repos/joshsoftware/khoj/commits").getComments_onDate("2011-12-26"))
    #test code for check commits on wrong date
    assert_equal(nil, Github.new("https://api.github.com/repos/joshsoftware/khoj/commits").getComments_onDate("2009-12-26"))
    #test code for check commits on wrong url
    assert_equal(nil, Github.new("https://api.github.com/repos/joshsoftware/").getComments_onDate("2011-12-26"))
    #test code for check how much commits given by given true name and true date
    assert_equal(1, Github.new("https://api.github.com/repos/joshsoftware/khoj/commits").checkName_date("2011-12-26","swapnil"))
    #test code for check how much commits given by given wrong name and true date
    assert_equal(0, Github.new("https://api.github.com/repos/joshsoftware/khoj/commits").checkName_date("2011-12-26","swapnil123"))
    #test code for true url checking
    assert_equal(true, Github.new("https://api.github.com/repos/joshsoftware/khoj/commits").check_url("https://api.github.com/repos/joshsoftware/khoj/commits"))
    #test code for wrong url checking
    assert_equal(false, Github.new("https://api.gits/joshsoftware/khoj/commits").check_url("https://api.gits/joshsoftware/khoj/commits"))
    #assert_equal(6,6 )
  end

end
