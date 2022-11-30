# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe '/users', type: :request do
  path '/users' do
    get 'List users' do
      tags 'Users'
      produces 'application/json'

      response 200, 'Users' do
        schema type: :object,
               properties: {
                 data: { type: :array, items: { '$ref' => '#/components/schemas/User' } }
               }
        let(:users_count) { rand(1..10) }
        before { create_list(:user, users_count) }

        run_test! do
          expect(json_body['data'].length).to eq(users_count)
        end
      end
    end

    post 'Create user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      description 'Create new user'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              role: { type: :string, enum: %w[admin job_seeker employer] }
            },
            required: %w[name email role]
          }
        }
      }

      response 201, 'Created' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/User' }
               }
        let(:user) do
          {
            user: {
              name: Faker::Name.name,
              email: Faker::Internet.email,
              role: %w[admin job_seeker employer].sample
            }
          }
        end

        run_test!
      end

      response 422, 'Unprocessable Entity' do
        let(:user) do
          {
            user: {
              name: ''
            }
          }
        end

        run_test! do
          expect(json_body['name']).to include(I18n.t('errors.messages.blank'))
        end
      end
    end
  end

  path '/users/{id}' do
    get 'Show user' do
      tags 'Users'
      produces 'application/json'
      description 'Show a user'
      parameter name: :id, in: :path

      response 200, 'Success' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/User' }
               }
        let(:id) { create(:user).id }
        run_test!
      end

      response 404, 'Not found' do
        let(:id) { 0 }
        run_test!
      end
    end

    put 'Update user' do
      tags 'Users'
      produces 'application/json'
      consumes 'application/json'
      description 'Update a user'
      parameter name: :id, in: :path
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              role: { type: :string, enum: %w[admin job_seeker employer] }
            },
            required: %w[name email role]
          }
        }
      }

      response 202, 'Updated' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/User' }
               }
        let(:id) { create(:user).id }
        let(:name) { Faker::Name.name }
        let(:user) do
          {
            user: {
              name: name
            }
          }
        end

        run_test! do
          expect(json_body.dig('data', 'attributes', 'name')).to eq(name)
        end
      end

      response 422, 'Unprocessable Entity' do
        let(:id) { create(:user).id }
        let(:user) do
          {
            user: {
              name: ''
            }
          }
        end

        run_test! do
          expect(json_body['name']).to include(I18n.t('errors.messages.blank'))
        end
      end
    end

    delete 'Destroy a user' do
      tags 'Users'
      produces 'application/json'
      description 'Destroy a user'

      parameter name: :id, in: :path

      response 204, 'Not contet' do
        let(:id) { create(:user).id }
        run_test! do
          expect(User.find_by(id: id)).to be_falsey
        end
      end

      response 404, 'Not found' do
        let(:id) { 0 }
        run_test!
      end
    end
  end
end
