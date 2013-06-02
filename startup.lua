-- Advanced Updater by DrWhat
-- Version 1.0 02/06/2013
 
-- Config
local author = "DrWhatNoName"
local project = "StorageSorter"
local branch = "master"
local screenw,screenh = term.getSize()
 
 
-- Do not edit unless you know what your doing
function loadTable(name)
  local file = fs.open(name,"r")
        local data = file.readAll()
        file.close()
        return textutils.unserialize(data)
end
 
function saveTable(table,name)
        local file = fs.open(name,"w")
        file.write(textutils.serialize(table))
        file.close()
end
-- Compile link
function getLink(file)
        return "https://raw.github.com/" .. author .. "/" .. project .. "/" .. branch .. "/" .. file
end
-- Download contents
function download(file, name)
        print("Downloading, " .. file)
        local data = http.get(getLink(file))
        if data then
                print(file .. " downloaded")
                local file = fs.open(name,"w")
                file.write(data.readAll())
                file.close()
                return true
        end
end
-- Check for updated versions
function updatePrograms()
        term.clear()
        term.setCursorPos(1,1)
        print("Checking for Updates...")
        if fs.exists("apconfig") then
                if download("config", "tmpconfig") then
                        config = loadTable("apconfig")
                        tmpconfig = loadTable("tmpconfig")
                        for key,value in pairs(tmpconfig) do
                                if tmpconfig[key]["version"] > config[key]["version"] then
                                        if fs.exists(key) then
                                                fs.delete(key)
                                        end
                                        download(key, tmpconfig[key]["path"])
                                end
                        end
                        fs.delete("apconfig")
                        saveTable(tmpconfig, "apconfig")
                        fs.delete("tmpconfig")
                       
                else
                        print("Unable to connect to http://github.com/")
                end
        else
                print("No config file was found.")
                if download("config", "apconfig") then
                        config = loadTable("apconfig")
                        for key,value in pairs(config) do
                                if fs.exists(key) then
                                        fs.delete(key)
                                end
                                download(key, config[key]["path"])
                        end
                else
                        print("Unable to connect to http://github.com/")
                end
        end
        print("All programs updated.")
        --print("Press any key to continue.")
        --skip()
end
 
-- RUN
-- parallel.waitForAny(printIntro, skip)
updatePrograms()
if fs.exists("storagesorter") then
        shell.run("storagesorter")
end