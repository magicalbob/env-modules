require 'spec_helper'
describe 'env_auditd' do
  context 'with default values for all parameters' do
    it { should contain_class('env_auditd') }
  end
end
