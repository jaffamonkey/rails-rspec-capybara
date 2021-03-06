require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
    subject(:user) { FactoryBot.create(:user) }
    subject(:goal) { FactoryBot.build(:goal) }

    describe 'GET #show' do
        it 'renders the goal show template' do
            goal.save!
            get :show, params: { id: goal.id }
            expect(response).to have_http_status(:success)
            expect(response).to render_template(:show)
        end
    end
end
