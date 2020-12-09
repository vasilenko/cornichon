require 'rails_helper'

RSpec.describe LinkCreator, type: :service do
  let(:url) { 'http://localhost' }
  let(:service) { described_class.new(url) }

  describe '#call' do
    subject { service.call }

    context 'when link for given url does not exist' do
      it 'creates new link' do
        expect { subject }.to change { Link.count }.by(1)
      end

      it 'returns created link' do
        is_expected.to eq Link.find_by!(url: url)
      end
    end

    context 'when link for given url already exists' do
      let!(:link) { Link.create(url: url, slug: 'myslug') }

      it 'does not create any link' do
        expect { subject }.not_to change { Link.count }
      end

      it 'returns existed link' do
        is_expected.to eq link
      end
    end

    context 'when given url is invalid' do
      let(:url) { 'ftp://localhost' }

      it 'does not create any link' do
        expect { subject }.not_to change { Link.count }
      end

      it 'returns nil' do
        is_expected.to be_nil
      end
    end
  end
end
