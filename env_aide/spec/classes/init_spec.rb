require 'spec_helper'
describe 'env_aide' do
  context 'with default values for all parameters' do
    it { should contain_class('env_aide') }
  end
end
