require 'spec_helper'
describe 'env_hosts' do
  context 'with default values for all parameters' do
    it { should contain_class('env_hosts') }
  end
end
