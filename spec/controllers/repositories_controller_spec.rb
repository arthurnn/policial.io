require 'rails_helper'

RSpec.describe RepositoriesController, type: :controller do
  let(:valid_attributes) { { name: 'volmer/repo' } }

  before do
    sign_in User.create!(uid: 123, token: '123abc')
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      allow_any_instance_of(Octokit::Client).to receive(
        :repositories).and_return([])
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      before do
        allow_any_instance_of(Octokit::Client).to receive(
          :create_hook).and_return({})
      end

      it 'creates a new repository' do
        expect do
          post :create, repository: valid_attributes
        end.to change(Repository, :count).by(1)
      end

      it 'redirects to the repository list with a successful message' do
        post :create, repository: valid_attributes
        expect(response).to redirect_to(repositories_url)
        expect(flash[:success]).to eq('Repository assimilated.')
      end
    end

    context 'with invalid params' do
      it 'redirects to the repository list with an error message' do
        post :create, repository: { name: '' }
        expect(response).to redirect_to(repositories_url)
        expect(flash[:alert]).to eq('Error trying to link the repository.')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:repository) { Repository.create!(valid_attributes) }

    it 'destroys the requested repository' do
      expect do
        delete :destroy, id: repository.to_param
      end.to change(Repository, :count).by(-1)
    end

    it 'redirects to the repository list with a successful message' do
      delete :destroy, id: repository.to_param
      expect(response).to redirect_to(repositories_url)
      expect(flash[:success]).to eq('Repository disabled.')
    end
  end
end
