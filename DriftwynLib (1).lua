local FileLogger = require(script.Utils.FileLog)

-- Environment setup
for _, Service in pairs({
	"ContentProvider",
	"CoreGui",
	"TweenService",
	"Players",
	"RunService",
	"HttpService",
	"UserInputService",
	"TextService",
	"StarterGui",
}) do
	wax.shared[Service] = cloneref(game:GetService(Service))
end

wax.shared.CobaltVerificationToken = wax.shared.HttpService:GenerateGUID()
wax.shared.SaveManager = require("Utils/SaveManager")
wax.shared.Settings = {}
wax.shared.Hooks = {}

-- UI setup
require("Utils/Connect")
wax.shared.ImageFetcher = require("Utils/ImageFetch")
wax.shared.LuaEncode = require("Utils/Serializer/LuaEncode")
wax.shared.Drag = require("Utils/Drag")
wax.shared.Interface = require("Utils/Interface")
wax.shared.Icons = require("Utils/Icons")
wax.shared.Animations = require("Utils/Animations")
wax.shared.Sonner = require("Utils/Sonner")
wax.shared.Highlighter = require("Utils/Highlighter")
wax.shared.Pagination = require("Utils/Pagination")
wax.shared.CodeGen = require("Utils/CodeGen")
wax.shared.Resize = require("Utils/Resize")
wax.shared.Hooking = require("Utils/Hooking")

-- Core Player Variables
if not wax.shared.Players.LocalPlayer then
	wax.shared.Players.PlayerAdded:Wait()
end
wax.shared.LocalPlayer = wax.shared.Players.LocalPlayer
wax.shared.PlayerScripts = cloneref(wax.shared.LocalPlayer:WaitForChild("PlayerScripts"))
wax.shared.ExecutorName = string.split(identifyexecutor(), " ")[1]

-- Utilities
wax.shared.gethui = gethui or function() return wax.shared.CoreGui end
wax.shared.checkcaller = checkcaller or function() return nil end
wax.shared.getrawmetatable = getrawmetatable or debug.getmetatable

-- restorefunction and newcclosure handling
wax.shared.restorefunction = function(Function, Silent)
	local Original = wax.shared.Hooks[Function]
	if Silent and not Original then return end
	assert(Original, "Function not hooked")
	if restorefunction and isfunctionhooked(Function) then
		restorefunction(Function)
	else
		wax.shared.Hooking.HookFunction(Function, Original)
	end
	wax.shared.Hooks[Function] = nil
end

wax.shared.newcclosure = wax.shared.ExecutorName == "AWP" and function(f)
	local env = getfenv(f)
	local x = setmetatable({ __F = f }, { __index = env, __newindex = env })
	local nf = function(...) return __F(...) end
	setfenv(nf, x)
	return newcclosure(nf)
end or newcclosure

-- Input Helpers
wax.shared.IsClickInput = function(Input)
	return Input.UserInputState == Enum.UserInputState.Begin and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch)
end
wax.shared.IsMoveInput = function(Input)
	return Input.UserInputState == Enum.UserInputState.Change and (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
end
wax.shared.IsMouseOverFrame = function(Frame, Position)
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
	return Position.X >= AbsPos.X and Position.X <= AbsPos.X + AbsSize.X and Position.Y >= AbsPos.Y and Position.Y <= AbsPos.Y + AbsSize.Y
end

-- Logging and Debugging
wax.shared.SetupLoggingConnection = function()
	if wax.shared.LogConnection then wax.shared.LogConnection:Disconnect() end
	wax.shared.LogFileName = `Cobalt/Logs/{DateTime.now():ToIsoDate():gsub(":", "_")}.log`
	local FileLog = FileLogger.new(wax.shared.LogFileName, FileLogger.LOG_LEVELS.INFO, true)

	return function(RemoteInstance, Type, CallOrderInLog)
		local LogEntry = wax.shared.Logs[Type][RemoteInstance]
		if not LogEntry then return end
		local CallDataFromHook = LogEntry.Calls[CallOrderInLog]
		local success, err = pcall(function()
			local generatedCode = wax.shared.CodeGen:BuildCallCode(setmetatable({
				Instance = RemoteInstance,
				Type = Type,
			}, { __index = CallDataFromHook }))

			local serializedEventData = wax.shared.LuaEncode({
				RemoteInstanceInfo = {
					Name = RemoteInstance.Name,
					ClassName = RemoteInstance.ClassName,
					Path = wax.shared.CodeGen.GetFullPath(RemoteInstance, true),
				},
				EventType = Type,
				CallOrderInLog = CallOrderInLog,
				DataFromHook = CallDataFromHook,
			}, { Prettify = true, InsertCycles = true, UseInstancePaths = true })

			local logMessage = table.concat({
				("Instance: %s (%s)"):format(RemoteInstance.Name, RemoteInstance.ClassName),
				("Path: %s"):format(wax.shared.CodeGen.GetFullPath(RemoteInstance, true)),
				("Call Order In Log: %s"):format(CallOrderInLog or "N/A"),
				"-------------------- Event Data --------------------",
				serializedEventData,
				"-------------------- Generated Code --------------------",
				generatedCode,
			}, "\n\t")

			FileLog:Info(Type .. ":" .. RemoteInstance.Name, logMessage)
		end)

		if not success then
			FileLog:Error("Logger", `Failed to log remote communication for {Type}:{RemoteInstance.Name} - {err}`)
		end
	end
end

if wax.shared.SaveManager:GetState("EnableLogging") then
	local LogConnection = wax.shared.SetupLoggingConnection()
	wax.shared.LogConnection = wax.shared.Connect(wax.shared.Communicator.Event:Connect(LogConnection))
end

-- Logs and Final Setup
wax.shared.Log = require("Utils/Log")
wax.shared.Logs = { Outgoing = {}, Incoming = {} }
wax.shared.NewLog = function(Instance, Type, Method, CallingScript)
	local Log = wax.shared.Log.new(Instance, Type, Method, wax.shared.GetTableLength(wax.shared.Logs[Type]) + 1, CallingScript)
	wax.shared.Logs[Type][Instance] = Log
	return Log
end

-- Final loading
require("ExecutorSupport")
require("Bypass")
require("Window")
require("Spy/Init")

wax.shared.Communicator = Instance.new("BindableEvent")

-- Delay check for anticheat
task.wait(1)
if wax.shared.AnticheatDisabled then
	wax.shared.Sonner.success(`Cobalt has bypassed {wax.shared.AnticheatName} (anticheat detected)`)
end
