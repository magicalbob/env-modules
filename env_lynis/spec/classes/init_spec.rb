require 'spec_helper'
describe 'env_lynis' do
  context 'with default values for all parameters' do
    it { should contain_class('env_lynis') }
  end
end
