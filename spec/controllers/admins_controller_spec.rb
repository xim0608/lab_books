require 'rails_helper'

RSpec.describe AdminsController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      login_admin
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
