local FontManager = {}

local CloneReference = (cloneref or clonereference or function(instance: any)
    return instance
end)

FontManager.Library = nil
FontManager.Folder = "Cortisol.Low/Assets"
FontManager.Fonts = {}

local HttpService: HttpService = CloneReference(game:GetService("HttpService"))

function FontManager:SetFolder(Folder: string)
    self.Folder = Folder
end

function FontManager:Build()
    local RegisterFont = function(Name, Weight, Style, Asset)
        local AssetPath = self.Folder .. "/" .. Asset.Id;

        if not isfile(AssetPath) or #readfile(AssetPath) < 100 then
            writefile(AssetPath, game:HttpGet(Asset.Font, true))
        end;

        local Data = {
            name = Name,
            faces = {
                {
                    name = "Regular",
                    weight = Weight,
                    style = Style,
                    assetId = getcustomasset(AssetPath)
                }
            }
        }

        local FontPath = self.Folder .. "/" .. Name .. ".Font"
        writefile(FontPath, HttpService:JSONEncode(Data))
        return getcustomasset(FontPath)
    end

    local Pixel = RegisterFont("Pixel", Enum.FontWeight.Regular, Enum.FontStyle.Normal, {
        Id = "Pixel.ttf",
        Font = "https://raw.githubusercontent.com/constantdump/assets/main/Pixel.ttf"
    })

    local Tahoma = RegisterFont("Tahoma", Enum.FontWeight.Regular, Enum.FontStyle.Normal, {
        Id = "Tahoma.ttf",
        Font = "https://raw.githubusercontent.com/constantdump/assets/main/Tahoma.ttf"
    })

    local Medodica = RegisterFont("Medodica", Enum.FontWeight.Regular, Enum.FontStyle.Normal, {
        Id = "Medodica.ttf",
        Font = "https://raw.githubusercontent.com/constantdump/assets/main/MedodicaRegular.ttf"
    })

    local Minecraftia = RegisterFont("Minecraftia", Enum.FontWeight.Regular, Enum.FontStyle.Normal, {
        Id = "Minecraftia.ttf",
        Font = "https://raw.githubusercontent.com/constantdump/assets/main/Minecraftia.ttf"
    })

    local Templeos = RegisterFont("Templeos", Enum.FontWeight.Regular, Enum.FontStyle.Normal, {
        Id = "Templeos.ttf",
        Font = "https://raw.githubusercontent.com/constantdump/assets/main/Templeos.ttf"
    })

    self.Fonts = {
        ["Pixel"] = Font.new(Pixel, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        ["Tahoma"] = Font.new(Tahoma, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        ["Medodica"] = Font.new(Medodica, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        ["Minecraftia"] = Font.new(Minecraftia, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
        ["Templeos"] = Font.new(Templeos, Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    }
end

function FontManager:SetLibrary(Library)
    self.Library = Library

    self:Build()
    Library.Fonts = self.Fonts

    function Library:GetFont(Name: string)
        return FontManager.Fonts[Name]
    end

    function Library:SetFontByName(Name: string)
        local FontFace = FontManager.Fonts[Name]
        if not FontFace then
            warn(string.format("FontManager: Font %q Was Not Found!", Name))
            return
        end

        Library:SetFont(FontFace)
    end
end

return FontManager
