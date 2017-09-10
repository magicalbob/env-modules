require 'spec_helper'
describe 'env_users' do
  context 'with default values for all parameters' do
    it { should contain_class('env_users') }
  end
end
