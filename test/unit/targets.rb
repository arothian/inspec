# encoding: utf-8
# author: Stephan Renatus

require 'helper'

describe Inspec::Targets::UrlHelper do
  let(:helper) { Inspec::Targets::UrlHelper.new }

  describe '#handles?' do
    it 'handles http' do
      helper.handles?('http://chef.io').must_equal true
    end

    it 'handles https' do
      helper.handles?('https://chef.io').must_equal true
    end

    it 'returns false if given an invalid URL' do
      helper.handles?('cheshire_cat').must_equal false
    end

    it 'returns false if given an URL with a protocol different from http[s]' do
      helper.handles?('gopher://chef.io').must_equal false
    end
  end

  describe '#resolve' do
    it 'resolves various github urls' do
      hlpr = Minitest::Mock.new
      helper.stub :resolve_zip, hlpr do
        %w{https://github.com/chef/inspec
           https://github.com/chef/inspec.git
           https://www.github.com/chef/inspec.git
           http://github.com/chef/inspec
           http://github.com/chef/inspec.git
           http://www.github.com/chef/inspec.git}.each do |github|
          hlpr.expect :call, nil, ['https://github.com/chef/inspec/archive/master.tar.gz', {}]

          helper.resolve(github)
        end
        hlpr.verify
      end
    end
  end
end
