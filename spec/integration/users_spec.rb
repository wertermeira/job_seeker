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
                 data: { type: :array, items: { '$ref' => '#/components/schemas/User' } },
                 included: { type: :array, items: { '$ref' => '#/components/schemas/Attachment' } }
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
              role: { type: :string, enum: User.roles.keys },
              attachments_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    title: { type: :string },
                    file_path: { type: :string, example: Faker::LoremFlickr.image },
                    kind: { type: :string, enum: Attachment.kinds.keys }
                  }
                }
              }
            },
            required: %w[name email role]
          }
        }
      }

      response 201, 'Created' do
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/User' },
                 included: { type: :array, items: { '$ref' => '#/components/schemas/Attachment' } }
               }
        let(:user) do
          {
            user: {
              name: Faker::Name.name,
              email: Faker::Internet.email,
              role: %w[admin job_seeker employer].sample,
              attachments_attributes: [
                {
                  kind: Attachment.kinds.keys.sample,
                  file_path: Faker::LoremFlickr.image,
                  title: Faker::Name.name
                }
              ]
            }
          }
        end

        run_test! do
          expect(json_body.dig('data', 'relationships', 'attachments', 'data').length).to eq(1)
        end
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
                 data: { '$ref' => '#/components/schemas/User' },
                 included: { type: :array, items: { '$ref' => '#/components/schemas/Attachment' } }
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
              role: { type: :string, enum: %w[admin job_seeker employer] },
              attachments_attributes: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer },
                    title: { type: :string },
                    file_path: { type: :string, example: Faker::LoremFlickr.image },
                    kind: { type: :string, enum: Attachment.kinds.keys },
                    _destroy: { type: :boolean }
                  }
                }
              }
            },
            required: %w[name email role]
          }
        }
      }

      response 202, 'Updated' do
        let(:user_object) { create(:user) }
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/User' },
                 included: { type: :array, items: { '$ref' => '#/components/schemas/Attachment' } }
               }
        let(:id) { user_object.id }
        let(:name) { Faker::Name.name }
        let(:new_title) { Faker::Name.name }
        let(:attachment) { create(:attachment, user: user_object) }

        context 'when update title from attachment' do
          let(:user) do
            {
              user: {
                name: name,
                attachments_attributes: [
                  {
                    id: attachment.id,
                    kind: Attachment.kinds.keys.sample,
                    title: new_title,
                    file_path: Faker::LoremFlickr.image
                  }
                ]
              }
            }
          end

          run_test! do
            expect(attachment.reload.title).to eq(new_title)
          end
        end

        context 'when destroy attachment' do
          let(:user) do
            {
              user: {
                name: name,
                attachments_attributes: [
                  {
                    id: attachment.id,
                    _destroy: true
                  }
                ]
              }
            }
          end

          run_test! do
            expect(Attachment.find_by(id: attachment.id)).to be_nil
          end
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
