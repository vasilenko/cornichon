require 'rails_helper'

RSpec.describe LinkCreator, type: :service do
  let(:url) { 'http://localhost' }
  let(:service) { described_class.new(url) }

  describe '#call' do
    context 'when link for given url does not exist' do
      it 'creates new link' do
        expect { service.call }.to change { Link.count }.by(1)
      end

      it 'returns slug for created link' do
        slug = service.call

        expect(slug).to be
        expect(Link.find_by(url: url, slug: slug)).to be
      end
    end

    context 'when link for given url already exists' do
      let(:slug) { 'myslug' }

      before { Link.create(url: url, slug: slug) }

      it 'does not create any link' do
        expect { service.call }.not_to change { Link.count }
      end

      it 'returns slug for existed link' do
        expect(service.call).to eq slug
      end
    end
  end
end
