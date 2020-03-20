wl_path_txt = "whitelist/whitelist.txt"
WhitelistedUsers = file.Exists(wl_path_txt,"DATA") and util.JSONToTable(file.Read(wl_path_txt,"DATA")) or {}

if not file.Exists("whitelist/", "DATA") then
    file.CreateDir("whitelist", "DATA")
    file.Append(wl_path_txt)
end

netstream.Hook("writeWL",function(client,sid)
    if client:IsAdmin() then
        if string.match(sid, "[1-10]") && string.len(sid) == 17 then
            if !table.HasValue(WhitelistedUsers, sid) then
                table.insert(WhitelistedUsers, sid)
                local tojson = util.TableToJSON(WhitelistedUsers)
                file.Write(wl_path_txt, tojson)
                client:notify("steamid writed to WL")
            else
                client:notify("steamidIsValid")
            end
        else
            client:notify("not matched")
        end
    end
end)

netstream.Hook("removeWL",function(client,sid)
    if client:IsAdmin() then
        if string.match(sid, "[1-10]") && string.len(sid) == 17 then
            if table.HasValue(WhitelistedUsers, sid) then
                table.RemoveByValue(WhitelistedUsers, sid)
                client:notify("steamid removed from wl")
                local tojson = util.TableToJSON(WhitelistedUsers)
                file.Write(wl_path_txt, tojson)
            else
                client:notify("steamidIsNotValid")
            end
        else
            client:notify("not matched")
        end
    end
end)

function PLUGIN:CheckPassword(sid64)
    if !table.HasValue(WhitelistedUsers, sid64) then
        return false, "Not Whitelisted"
    end
end

hook.Add("PlayerSay", "openwl", function(target, text, _)
    if text == "!wlmenu" then
        if target:IsAdmin() then
            netstream.Start(target,"openwlmenu")
            return true
        else
            target:notify("this feature for admins")
        end
    end
end)