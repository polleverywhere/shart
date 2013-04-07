require 'spec_helper'

describe Shart::Engine do
  let(:engine) { Shart::Engine.new }

  it "should process rules" do
    s3_object = mock()
    s3_object.stub!(:key)
    s3_object.stub!(:attribute)
    s3_object.should_receive(:key) { 'shart.gemspec' }
    s3_object.should_receive(:attribute).with(:cache_control, 'max-age=100')

    engine.rule('*.gemspec'){ attribute :cache_control, 'max-age=100' }
    engine.process s3_object
  end
end