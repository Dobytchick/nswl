PLUGIN.name = "Whitelist"
PLUGIN.desc = "Simple whitelist"
PLUGIN.author = "Dobytchick"

if SERVER then
    nut.util.include("sv_plugin.lua")

local function AddDefaultSteamID64(sid64)
	WhitelistedUsers[sid64] = true
end
    
    AddDefaultSteamID64("76561198251000796") -- insert you steamID
end

if CLIENT then
	
hook.Add("LoadFonts", "WLFONTS", function(font, genericFont)
	surface.CreateFont("GmzArial",
	{
		font = "Arial",
		size = ScreenScale(8),
		weight = 150,
		antialias = true,
		extended = true
	})
end)
	
    netstream.Hook("openwlmenu",function(client)
        if LocalPlayer():IsAdmin() then
            frame = vgui.Create("DFrame")
            frame:SetSize(math.floor(ScrW() * 0.31), math.floor(ScrH() * 0.2))
            frame:Center()
            frame:ShowCloseButton(true)
            frame:SetTitle("WLMANAGER")
            frame:MakePopup()
            local opacity = 0
            frame.Paint = function(s,w,h)
                opacity = Lerp(0.003, opacity, 255)
                nut.util.drawBlur(s,3)
                surface.SetDrawColor(0, 0, 0, 150)
                surface.DrawRect(0, 0, w, h)

                surface.SetDrawColor(246, 225, 196,150)
                surface.DrawOutlinedRect(0, 0, w, h)

                surface.SetDrawColor(246, 225, 196,150)
                surface.DrawRect(0, 0, w, h * 0.1)

                draw.DrawText("Enter the SteamID of the player you want to interact with", "GmzArial", w * 0.5, h * 0.2, Color(255,255,255,opacity), TEXT_ALIGN_CENTER)
            end

            textentri = frame:Add("DTextEntry")
            textentri:SetSize(math.floor(ScrW() * 0.17),math.floor(ScrH() * 0.02))
            textentri:SetPos(math.floor(ScrW() * 0.072), math.floor(ScrH() * 0.08))
            textentri.Paint = function(s,w,h)
                surface.SetDrawColor(246, 225, 196,150)
                surface.DrawOutlinedRect(0, 0, w, h)
                s:DrawTextEntryText(color_white, color_white, color_white)
            end

            btn_add = frame:Add("DButton")
            btn_add:SetSize(math.floor(ScrW() * 0.17),math.floor(ScrH() * 0.02))
            btn_add:SetText("ADD TO WL")
            btn_add:SetPos(math.floor(ScrW() * 0.072), math.floor(ScrH() * 0.12))
            btn_add.DoClick = function()
                netstream.Start("writeWL",textentri:GetText())
            end

            btn_remove = frame:Add("DButton")
            btn_remove:SetSize(math.floor(ScrW() * 0.17),math.floor(ScrH() * 0.02))
            btn_remove:SetText("REMOVE TO WL")
            btn_remove:SetPos(math.floor(ScrW() * 0.072), math.floor(ScrH() * 0.15))
            btn_remove.DoClick = function()
                netstream.Start("removeWL",textentri:GetText())
            end
        end
    end)
end
