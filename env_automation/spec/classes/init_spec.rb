require 'spec_helper'
describe 'env_automation' do
  context 'with default values for all parameters' do
    it { should contain_class('env_automation') }
  end
end
