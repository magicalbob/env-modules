require 'spec_helper'
describe 'env_sysctl' do
  context 'with default values for all parameters' do
    it { should contain_class('env_sysctl') }
  end
end
