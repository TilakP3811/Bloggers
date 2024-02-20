# frozen_string_literal: true

shared_examples 'returns 200' do
  it 'returns 200' do
    expect(response).to have_http_status(:ok)
  end
end

shared_examples 'returns 401' do
  it 'returns 401' do
    expect(response).to have_http_status(:unauthorized)
  end
end

shared_examples 'returns 422' do
  it 'returns 422' do
    expect(response).to have_http_status(:unprocessable_entity)
  end
end
