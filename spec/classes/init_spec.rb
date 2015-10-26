require 'spec_helper'
describe 'resource_refresh' do

  context 'with defaults for all parameters' do
    it { should contain_class('resource_refresh') }
  end
end
