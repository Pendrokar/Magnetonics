VFS.Include(Script.GetName() .. '/gadgets.lua', nil, VFS.ZIP_ONLY)

local TESTS_DIR = Script.GetName():gsub('US$', '') .. '/tests' -- for me this is /Luarules/Tests
Spring.Echo("TESTS_DIR: " .. TESTS_DIR)
local gadgetFiles = VFS.DirList(TESTS_DIR, "*.lua", VFSMODE)

local CONFIGVAR = "CurrentTest"
local currentTest = Spring.GetConfigString(CONFIGVAR)
if not VFS.FileExists(currentTest, VFSMODE) then
	currentTest = ""
end
local currentGadget

function gadgetHandler:NextTest()
	local found = false
	for k,gf in ipairs(gadgetFiles) do
		Spring.Echo(gf)
		if found or currentTest == "" then
			gadgetHandler:StartTest(gf)
			return
		end
		if gf == currentTest then
			found = true
		end
	end
	Spring.SetConfigString(CONFIGVAR,"")
	Spring.Echo("All tests run, exiting!")
	Spring.SendCommands("quit")
end

function gadgetHandler:TestDone(result, msg)
	Spring.Echo("Test " .. currentTest .. " is done: " .. (result and "true" or "false") .. ", message: " .. msg)
	gadgetHandler:RemoveGadget(currentGadget)
	gadgetHandler:NextTest()
end

function gadgetHandler:StartTest(testfile)
	Spring.Echo("Starting test " .. testfile)
	Spring.SetConfigString(CONFIGVAR, testfile)
	local currentGadget = gadgetHandler:LoadGadget(testfile)
	gadgetHandler:InsertGadget(currentGadget)
	currentGadget.TestDone = gadgetHandler.TestDone
end

if currentTest == "" then
	gadgetHandler:NextTest(currentTest)
else
	gadgetHandler:StartTest(currentTest)
end