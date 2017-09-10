require 'spec_helper'
describe 'env_fail2ban' do
  context 'with default values for all parameters' do
    it { should contain_class('env_fail2ban') }
  end
end
