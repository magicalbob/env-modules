require 'spec_helper'
describe 'env_rkhunter' do
  context 'with default values for all parameters' do
    it { should contain_class('env_rkhunter') }
  end
end
