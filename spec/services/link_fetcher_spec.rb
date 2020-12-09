require 'rails_helper'

RSpec.describe LinkFetcher, type: :service do
  let(:slug) { 'myslug' }
  let(:service) { described_class.new(slug) }

  describe '#call' do
    subject { service.call }

    context 'when link with given slug exists' do
      let!(:link) { Link.create(url: 'http://localhost', slug: slug) }

      it 'increments visitor_count by 1' do
        expect { subject }.to change { link.reload.visit_count }.by(1)
      end

      it 'returns link' do
        is_expected.to eq link
      end
    end

    context 'when link with given slug does not exist' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
