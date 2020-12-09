require 'rails_helper'

RSpec.describe 'Urls API', type: :request do
  let(:slug) { 'myslug' }
  let(:url) { 'http://localhost' }

  describe 'POST /urls' do
    before { post '/urls', params: { url: url } }

    context 'when given url is valid' do
      it 'responds with slug for given url' do
        expect(response).to be_created
        expect(response_body[:slug]).to be
      end
    end

    context 'when given url is not valid' do
      let(:url) { 'ftp://localhost' }

      it 'responds with 422 Unprocessable Entity' do
        expect(response).to have_http_status 422
        expect(response_body[:error]).to be
      end
    end
  end

  describe 'GET /urls/:slug' do
    let!(:link) { Link.create(url: url, slug: slug) }

    it 'responds with url for given slug' do
      get "/urls/#{slug}"

      expect(response).to be_ok
      expect(response_body[:url]).to eq url
    end

    it 'increments with visit_count on link with given slug' do
      expect { get "/urls/#{slug}" }.to change { link.reload.visit_count }.by(1)
    end
  end

  describe 'GET /urls/:slug/stats' do
    let!(:link) { Link.create(url: url, slug: slug, visit_count: 5) }

    it 'responds with visit_count for given slug' do
      get "/urls/#{slug}/stats"

      expect(response).to be_ok
      expect(response_body[:visit_count]).to eq link.visit_count
    end
  end
end
