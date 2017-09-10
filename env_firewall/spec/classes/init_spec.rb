require 'spec_helper'
describe 'env_firewall' do
  context 'with default values for all parameters' do
    it { should contain_class('env_firewall') }
  end
end
