local http = require "resty.http"
local json = require "cjson"

local TokenHandler = {
  PRIORITY = 1000,
  VERSION = "0.1",
}

function TokenHandler:access(conf)
  kong.log.inspect(conf)

  local jwt_token = kong.request.get_header("Authorization")
  if not jwt_token then
    ngx.log(ngx.DEBUG, "Token not found in header")
    ngx.redirect("/error")
  end
  ngx.log(ngx.DEBUG, jwt_token)

  local token_type = jwt_token:sub(0,7)
  if token_type ~= "Bearer " then
    ngx.log(ngx.DEBUG, "Invalid token type: ", token_type)
    kong.response.exit(401)
  end
  
  ngx.log(ngx.DEBUG, conf.auth_host, conf.auth_port)

  local httpc = http.new()
  httpc:connect(conf.auth_host, conf.auth_port)
  
  local res, err = httpc:request({
    method = "GET",
    path = conf.auth_urlpath,
    headers = {
      ["Content-Type"] = "application/json",
      ["Authorization"] = jwt_token
    },
  })

  if not res then
    kong.log.err("Failed to call auth_endpoint:", err)
    return kong.response.exit(500)
  end

  if res.status ~= 200 then
    ngx.log(ngx.DEBUG, "Authentication failed", res.status)
    return kong.response.exit(401) -- unauthorized
  end
end

return TokenHandler