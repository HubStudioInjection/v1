local Get = true
if Get == true then
getgenv().local.Api = loadstring(game:HttpGet(".. scr/Api.lua .."))()
  getgenv().local.Api.Parent = loadstring(game:HttpGet(".. Protogen.Genic Example.lua .."))()
     getgenv().local.ESP.Source = loadstring(game:HttpGet(".. ESP .."))()
       getgenv().local.ESP.Parent = loadstring(game:HttpGet(".. Protogen.Genic Example.lua .."))()
         getgenv().local.Tracers.Source = loadstring(game:HttpGet(".. Tracers .."))()
           getgenv().local.Tracers.Parent = loadstring(game:HttpGet(".. Protogen.Genic Example.lua .."))()
end
