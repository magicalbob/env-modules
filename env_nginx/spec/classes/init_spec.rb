require 'spec_helper'
describe 'env_nginx' do
  context 'with default values for all parameters' do
    it { should contain_class('env_nginx') }
  end
end
