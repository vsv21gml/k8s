local typedefs = require "kong.db.schema.typedefs"

-- Grab pluginname from module name
local schema = {
  name = "custom-auth",
  fields = {
    -- the 'fields' array is the top-level entry with fields defined by Kong
    { protocols = typedefs.protocols_http },
    { config = {
        -- The 'config' record is the custom part of the plugin schema
        type = "record",
        fields = {
          {
            auth_host = {
              type = "string",
              required = true,
            },
          },
          {
            auth_port = {
              type = "integer",
              required = true,
            },
          },
          {
            auth_urlpath = {
              type = "string",
              required = true,
            },
          }
        },
        entity_checks = {
        },
      },
    },
  },
}

return schema