require File.dirname(__FILE__) + '/../spec_helper'


describe CompatabilityReader do

	TEST_FILE = File.dirname(__FILE__) + '/../test_compatability.yml'
	before :each do
		@reader = CompatabilityReader.new
	end

	it "should read all components in the compatability yml" do
		components = @reader.read TEST_FILE
		components.length.should == 2
	end

	it "should parse all component's information" do
		components = @reader.read TEST_FILE
		component_exists_in? components, :not_required_controller, false
		component_exists_in? components, :required_controller, true
	end
end

private
	def component_exists_in?(components, controller, ssl_required)
		check = components.select { |c| c.controller == controller && c.ssl_required == ssl_required }	
		return check.length == 1
	end