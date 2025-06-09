-- Config mặc định nếu chưa có
getgenv().Gag = getgenv().Gag or {
    ["GaG"] = {
        ["SelectPet"] = "", -- E.g : Raccoon,Dragonfly,Queen Bee,Snail,Beaver,Ant,Woodpecker,Butterfly,Crab,Fox,Frog,Grasshopper,Hedgehog,Mouse,Owl,Penguin,Polar Bear,Porcupine,Rabbit,Squirrel,Turkey,Walrus,Weasel,Whale,Wolf,Zebra
    },
    ["Hop Server"] = {
        ["Delay"] = "10", -- seconds before server hop
    },
    ["Script"] = {
        ["AutoLoad"] = "true",
    }
}

local DataSer = require(game:GetService("ReplicatedStorage").Modules.DataService)
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Load notification library
local ThongBao = loadstring(game:HttpGet("https://raw.githubusercontent.com/NomDomHub/npmc_/refs/heads/main/Notification.lua"))()

-- Hàm tách chuỗi pet
local function splitPets(str)
    local pets = {}
    if not str or str == "" then return pets end
    for pet in string.gmatch(str, '([^,]+)') do
        pet = pet:gsub("^%s*(.-)%s*$", "%1") -- trim spaces
        table.insert(pets, pet)
    end
    return pets
end

-- Lấy danh sách pet mục tiêu
local targetPets = splitPets(getgenv().Gag["GaG"]["SelectPet"])

if not getgenv().Gag["GaG"]["SelectPet"] or #targetPets == 0 then
    ThongBao:Notify({
        Title = "Warning",
        Content = "No target pet set! Kicking...",
        Duration = 3
    })
    task.wait(3)
    LocalPlayer:Kick("No target pet set.")
    return
end

local hopDelay = tonumber(getgenv().Gag["Hop Server"]["Delay"]) or 10

-- Hàm main loop
local function mainLoop()
    while true do
        task.wait(1)
        local found = false

        for _, obj in pairs(DataSer:GetData().SavedObjects) do
            if obj.ObjectType == "PetEgg" and obj.Data.RandomPetData and obj.Data.CanHatch then
                local petName = obj.Data.RandomPetData.Name
                for _, targetName in pairs(targetPets) do
                    if petName == targetName then
                        found = true
                        break
                    end
                end
            end
            if found then break end
        end

        if found then
            ThongBao:Notify({
                Title = "Pet Found",
                Content = "Target pet found! Server hopping in "..hopDelay.." seconds.",
                Duration = 3
            })
            task.wait(hopDelay)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
            break
        else
            ThongBao:Notify({
                Title = "Not Found",
                Content = "Target pet not found! Kicking and rejoining.",
                Duration = 3
            })
            task.wait(3)
            LocalPlayer:Kick("Target pet not found.")
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
            break
        end
    end
end

-- Auto load support (rejoin / teleport / restart)
if getgenv().Gag["Script"]["AutoLoad"] == "true" then
    spawn(mainLoop)
end
