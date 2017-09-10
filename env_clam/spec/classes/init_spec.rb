require 'spec_helper'
describe 'env_clam' do
  context 'with default values for all parameters' do
    it { should contain_class('env_clam') }
  end
end
