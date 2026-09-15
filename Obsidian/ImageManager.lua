local ImageManager = {}
ImageManager.__index = ImageManager

local Library;

local Repository = "https://raw.githubusercontent.com/feofelact/UI-Library-s/refs/heads/main/"

local ImageManagerAssets = {
    TransparencyTexture = {
        RobloxId = 139785960036434,
        Path = "UI-Library-s/Obsidian/Assets/TransparencyTexture.png",
        URL = Repository .. "Assets/TransparencyTexture.png",
        Id = nil,
    },

    SaturationMap = {
        RobloxId = 4155801252,
        Path = "UI-Library-s/Obsidian/Assets/SaturationMap.png",
        URL = Repository .. "Assets/SaturationMap.png",
        Id = nil,
    },
}

local function CreatePath(Path: string, IsFile: boolean?)
    if not isfolder or not makefolder then
        return
    end

    local Segments = Path:split("/")
    local TraversedPath = ""

    if IsFile then
        table.remove(Segments, #Segments)
    end

    for _, Segment in ipairs(Segments) do
        if not isfolder(TraversedPath .. Segment) then
            makefolder(TraversedPath .. Segment)
        end

        TraversedPath = TraversedPath .. Segment .. "/"
    end

    return TraversedPath
end

function ImageManager.AddAsset(AssetName: string, RobloxAssetId: number, URL: string, ForceRedownload: boolean?)
    if ImageManagerAssets[AssetName] ~= nil then
        error(string.format("Asset %q Already Exists", AssetName))
    end

    assert(typeof(RobloxAssetId) == "number", "Roblox Asset Id Must be a Number")

    ImageManagerAssets[AssetName] = {
        RobloxId = RobloxAssetId,
        Path = string.format("Cortisol.Low/CustomAssets/%s", AssetName),
        URL = URL,
        Id = nil,
    }

    ImageManager.DownloadAsset(AssetName, ForceRedownload)
end

function ImageManager.GetAsset(AssetName: string)
    if not ImageManagerAssets[AssetName] then
        return nil
    end

    local AssetData = ImageManagerAssets[AssetName]
    if AssetData.Id then
        return AssetData.Id
    end

    local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

    if getcustomasset then
        local Success, NewID = pcall(getcustomasset, AssetData.Path)

        if Success and NewID then
            AssetID = NewID
        end
    end

    AssetData.Id = AssetID
    return AssetID
end

function ImageManager.DownloadAsset(AssetName: string, ForceRedownload: boolean?)
    if not getcustomasset or not writefile or not isfile then
        return false, "missing functions"
    end

    local AssetData = ImageManagerAssets[AssetName]

    CreatePath(AssetData.Path, true)

    if ForceRedownload ~= true and isfile(AssetData.Path) then
        return true, nil
    end

    local Success, Error = pcall(function()
        writefile(AssetData.Path, game:HttpGet(AssetData.URL))
    end)

    return Success, Error
end

function ImageManager:SetLibrary(Library)
    Library = Library
    Library.ImageManager = self

    for AssetName, _ in ImageManagerAssets do
        self.DownloadAsset(AssetName)
    end

    return self
end

return ImageManager
