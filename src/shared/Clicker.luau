local module = {}
module.__index = module

local asset_id: string = "rbxassetid://18459009770"

-- Manual Type
export type Clicker = {
	Button: ImageButton,
	OnClickCon: RBXScriptConnection,
	OnHoverCon: RBXScriptConnection,
	EndHoverCon: RBXScriptConnection,
	OnReleaseCon: RBXScriptConnection,
	New: (screen: ScreenGui) -> Clicker,
	OnClick: (func: (...any) -> ()) -> (),
	OnHover: (func: (...any) -> ()) -> (),
	Destroy: () -> (),
}

-- Constructor
function module.New(screen: ScreenGui)
	-- Create instance
	local self = setmetatable(module, {})
	local button: ImageButton = Instance.new("ImageButton")
	button.Parent = screen
	button.Name = "CookieButton"
	button.Image = asset_id
	button.BackgroundTransparency = 1
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.Position = UDim2.fromScale(0.75, 0.5)
	button.Size = UDim2.fromScale(0.2, 0.2)
	self.Button = button

	-- Aspect Ratio Constraint (make the button square)
	local UIA: UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIA.Parent = button

	-- Self auto cleaning
	self.Button.Destroying:Once(self.Destroy)
	return self
end

-- Events
function module.OnClick(self: Clicker, func: (...any) -> ())
	self.OnClickCon = self.Button.MouseButton1Down:Connect(function()
		func()
	end)
end

function module.OnRelease(self: Clicker, func: (...any) -> ())
	self.OnReleaseCon = self.Button.MouseButton1Up:Connect(function()
		func()
	end)
end

function module.OnHover(self: Clicker, func: (...any) -> ())
	self.OnHoverCon = self.Button.MouseEnter:Connect(function()
		func()
	end)
end

function module.EndHover(self: Clicker, func: (...any) -> ())
	self.EndHoverCon = self.Button.MouseLeave:Connect(function()
		func()
	end)
end

-- Destroy
function module.Destroy(self)
	self.Button:Destroy()
	self.OnClickCon:Disconnect()
	self.OnHoverCon:Disconnect()
	self.EndHoverCon:Disconnect()
	self.OnReleaseCon:Disconnect()
	self = nil
end

return module
