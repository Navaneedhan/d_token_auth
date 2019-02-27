require 'test_helper'
require 'generators/d_token_auth/d_token_auth_generator'

module DTokenAuth
  class DTokenAuthGeneratorTest < Rails::Generators::TestCase
    tests DTokenAuthGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
