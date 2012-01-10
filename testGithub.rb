require "./github.rb"
require "test/unit"
class TestGithub < Test::Unit::TestCase
include(Github_methods)
  def test_simple
    #test code true Url fetch data or not
    assert_equal(Array, Module_class.new().request_url("https://api.github.com/repos/joshsoftware/khoj/commits").class)
    #test code false Url fetch data or not
    assert_equal({"message"=>"Not Found"}, Module_class.new().request_url("https://api.github.com/repos/jos123hsoftware/khoj/commitsasd"))
    #test url is valid or not for non valid url
    assert_equal(nil, Module_class.new().request_url("/api.github.com/repos/joshsoftware/khoj/commits"))
    #test code for add_data_hash method if key not present in hash then it returns 1
    assert_equal(1, Module_class.new().hash_data_add({},'12'))
    #test code for add_data_hash method if key present in hash then increment the key value
    assert_equal(4, Module_class.new().hash_data_add({'12' => 3},'12'))
    #test code for add_data_hash method if key present in hash then increment the key value
    assert_equal(Hash, Github.new("https://api.github.com/repos/joshsoftware/khoj/commits").data_operation().class)
  end
end
