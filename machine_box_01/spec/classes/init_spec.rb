require 'spec_helper'
describe 'machine_env_dev_proxy' do
  context 'with default values for all parameters' do
    it { should contain_class('machine_env_dev_proxy') }
  end
end
