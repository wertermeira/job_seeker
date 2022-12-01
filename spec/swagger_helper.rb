# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      components: {
        schemas: {
          Attachment: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, example: 'attachments' },
              attributes: {
                type: :object,
                properties: {
                  title: { type: :string },
                  kind: { type: :string, enum: Attachment.kinds.keys },
                  file_path: { type: :string, example: Faker::LoremFlickr.image }
                }
              }
            }
          },
          User: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string, example: 'users' },
              attributes: {
                type: :object,
                properties: {
                  name: { type: :string },
                  email: { type: :string, example: 'email@app.com' },
                  role: { type: :string, enum: User.roles.keys },
                  attachment_count: {
                    type: :object,
                    properties: {
                      resume: { type: :integer },
                      cover_letter: { type: :integer },
                      photo: { type: :integer }
                    }
                  }
                },
                required: %w[name email role]
              },
              relationships: {
                type: :object,
                properties: {
                  attachments: {
                    type: :object,
                    properties: {
                      data: {
                        type: :array,
                        items: {
                          type: :object,
                          properties: {
                            id: { type: :string },
                            type: { type: :string, example: 'attachments' }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      },
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000'
            }
          }
        }
      ]
    }
  }

  config.swagger_format = :yaml
end
