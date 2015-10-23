require 'spec_helper'
describe 'service_charm' do

  context 'with defaults for all parameters' do
    it { should contain_class('service_charm') }
  end
end
