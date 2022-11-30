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
                  role: { type: :string, enum: %w[admin job_seeker employer] }
                },
                required: %w[name email role]
              }
            }
          }
        },
        securitySchemes: {
          bearer: {
            type: :http,
            scheme: :bearer
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
