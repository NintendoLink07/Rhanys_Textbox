SLASH_RTB1, SLASH_RTB2 = '/rtb', '/rhanystextbox' -- 3.
function SlashCmdList.RTB(msg, editbox) -- 4.
	rtbOpenWindow()
end

local function OnEvent(self, event, ...)
	--print(event, ...)
	if(event == "PLAYER_ENTERING_WORLD") then
		isLogin, isReload = ...
		rtbLoadDefaults()
		
		if(not isLogin and not isReload) then
			--name, description, bgImage, buttonImage1, loreImage, buttonImage2, dungeonAreaMapID, link, shouldDisplayDifficulty, mapID = EJ_GetInstanceInfo([journalInstanceID])
			
			name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
			
			if(instanceType == "party") then
				--print("LAST: "..lastDungeon)
				--print("NAME: "..name)
				--print("ID: "..instanceID)
				lastDungeon = instanceID
				
				dungeonDropMenu:SetValue(lastDungeon, name)
			end
		else
			--print(isLogin, isReload)
			if(isReload) then
				--rtbInitializeSavedVars()
			end
		end
		--openWindow()
	elseif(event == "PLAYER_LOGIN") then
		rtbInitializeSavedVars()
	end
end

function rtbOpenWindow()
	rtbMainFrame:Show()
	rtbScrollFrame:Show()
	rtbScrollChild:Show()
end

function rtbCloseWindow()
	rtbMainFrame:Hide()
	rtbScrollFrame:Hide()
	rtbScrollChild:Hide()

end

function rtbInitializeSavedVars()
	if(dungeonTexts == nil) then
		dungeonTexts = {}
	end
	
	if(lastDungeon == nil) then
		lastDungeon = 2521
	end 
	
	if(dungeonTexts[lastDungeon] ~= nil) then
		eb:SetText(dungeonTexts[lastDungeon])
	end
	
	if(locked == nil) then
		locked = false
	end
	
	if(locked) then
		--rtbMainFrame:SetMovable(false)
		rtbMainFrame:EnableMouse(false)
		rtbLock.backdropInfo = backdropInfoLockUp
		locked = true
		
		rtbResizeGrabber:Hide()
		rtbSlider:Hide()
		dungeonDropMenu:Hide()
		rtbMainFrame.closeButton:Hide()
		rtbLock:ClearAllPoints()
		rtbLock:SetPoint("TOPLEFT", 0, 0)
		eb:Disable()
		
		rtbMainFrame:ClearBackdrop()
	else
		--rtbMainFrame:SetMovable(true)
		rtbMainFrame:EnableMouse(true)
		rtbLock.backdropInfo = backdropInfoUnlockUp
		locked = false
		
		rtbResizeGrabber:Show()
		rtbSlider:Show()
		dungeonDropMenu:Show()
		rtbMainFrame.closeButton:Show()
		rtbLock:ClearAllPoints()
		rtbLock:SetPoint("TOPRIGHT", -rtbMainFrame.closeButton:GetWidth(), 0)
		eb:Enable()
		
		rtbMainFrame.backdropInfo = rtbMainFrameBackdropInfo
		rtbMainFrame:ApplyBackdrop()
	end
	
	rtbLock:ApplyBackdrop()
end

function rtbLoadDefaults()
	UIDropDownMenu_SetSelectedValue(dungeonDropMenu, lastDungeon)
	UIDropDownMenu_SetText(dungeonDropMenu, GetRealZoneText(lastDungeon))
end
 
function rtbResizeFrame(frame, resizeChildFrames) --https://www.wowinterface.com/forums/showthread.php?t=48862
    local Width = frame:GetWidth()
    local Height = frame:GetHeight()
    local rtbResizeGrabber = CreateFrame("Frame", nil, frame)
    rtbResizeGrabber:SetPoint("BottomRight", frame, "BottomRight", 0, 0)
    rtbResizeGrabber:SetWidth(16)
    rtbResizeGrabber:SetHeight(16)
    rtbResizeGrabber:SetFrameLevel(frame:GetFrameLevel() + 7)
    rtbResizeGrabber:EnableMouse(true)
    local rtbResizeTexture = rtbResizeGrabber:CreateTexture(nil, "Artwork")
    rtbResizeTexture:SetPoint("TopLeft", rtbResizeGrabber, "TopLeft", 0, 0)
    rtbResizeTexture:SetWidth(16)
    rtbResizeTexture:SetHeight(16)
    rtbResizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	
	if(frame:GetResizeBounds() == nil) then
		frame:SetResizeBounds(Width / 1.5, Height / 1.5, Width * 1.5, Height * 1.5)
	else
		minW, minH, maxW, maxH = frame:GetResizeBounds()
	end
	
    frame:SetResizable(true)
    rtbResizeGrabber:SetScript("OnEnter", function(self)
        rtbResizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    end)
    rtbResizeGrabber:SetScript("OnLeave", function(self)
        rtbResizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    end)
    rtbResizeGrabber:SetScript("OnMouseDown", function(self, button)
        if button == "RightButton" then
            frame:SetWidth(Width)
            frame:SetHeight(Height)
        else
            rtbResizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
            frame:StartSizing("Bottomright")
        end
    end)
    rtbResizeGrabber:SetScript("OnMouseUp", function(self, button)
	rtbResizeGrabber:SetResizeBounds(frame:GetResizeBounds())
        local x, y = GetCursorPosition()
        local fx = self:GetLeft() * self:GetEffectiveScale()
        local fy = self:GetBottom() * self:GetEffectiveScale()
        if x >= fx and x <= (fx + self:GetWidth()) and y >= fy and y <= (fy + self:GetHeight()) then
            rtbResizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        else
            rtbResizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        end
        frame:StopMovingOrSizing()
    end)
    local scrollframe = CreateFrame("ScrollFrame", nil, frame)
    scrollframe:SetWidth(Width)
    scrollframe:SetHeight(Height)
    scrollframe:SetPoint("Topleft", frame, "Topleft", 0, 0)
	scrollframe:SetResizeBounds(frame:GetResizeBounds())
	frame:SetScript("OnSizeChanged", function(self)
		local s = self:GetWidth() / Width
		scrollframe:SetScale(s)
			
		if(resizeChildFrames) then
			local childrens = {self:GetChildren()}
			for _, child in ipairs(childrens) do
				if child ~= rtbResizeGrabber then
					child:SetScale(s)
					mainScale = s
				end
			end
			
			
		end
			
		--self:SetHeight(Height * s)
			
		eb:SetSize(frame:GetWidth() - 35, frame:GetHeight())
	end)
end

function rtbCreateMinimapButton()
	local addon = LibStub("AceAddon-3.0"):NewAddon("Rhany's Textbox", "AceConsole-3.0")
	local rtbLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Rhany's Textbox", {
		type = "data source",
		text = "Rhany's Textbox",
		icon = "Interface\\Icons\\Achievement_Dungeon_Mythic15",
		OnClick = function() 
			if(rtbMainFrame:IsVisible()) then
				rtbCloseWindow()
			else 
				rtbOpenWindow() 
			end
		end,
		OnTooltipShow = function(tooltip)
			if not tooltip or not tooltip.AddLine then return end
			tooltip:AddLine("Rhany's Textbox|r")
			tooltip:AddLine("Click to toggle AddOn Window")
		end,
	})
	local icon = LibStub("LibDBIcon-1.0")
	 
	function addon:OnInitialize()
		self.db = LibStub("AceDB-3.0"):New("rtbDB", {
			profile = {
				minimap = {
					hide = false,
				},
			},
		})
		icon:Register("Rhany's Textbox", rtbLDB, self.db.profile.minimap)
		self:RegisterChatCommand("rtb2", "RTBShow")
	end
	 
	function addon:RTBShow()
		self.db.profile.minimap.hide = not self.db.profile.minimap.hide
		if self.db.profile.minimap.hide then
			icon:Hide("Rhany's Textbox")
		else
			icon:Show("Rhany's Textbox")
		end
	end
end
 

function rtbInitializeFrames()
	rtbCreateMinimapButton()

	rtbMainFrame = CreateFrame("Frame", "RTBMainFrame", nil, "BackdropTemplate")
	rtbMainFrame:SetMovable(true)
	rtbMainFrame:EnableMouse(true)
	rtbMainFrame:RegisterForDrag("LeftButton")
	rtbMainFrame:SetScript("OnDragStart", rtbMainFrame.StartMoving)
	rtbMainFrame:SetScript("OnDragStop", rtbMainFrame.StopMovingOrSizing)
	rtbMainFrame:SetPoint("TOPLEFT", 5, -5)
	rtbMainFrame:SetWidth(320)
	rtbMainFrame:SetHeight(360)
	rtbMainFrame:SetFrameStrata("DIALOG")
	
	screenWidth = floor(GetScreenWidth() / GetCVar("RenderScale"))
	screenHeight = floor(GetScreenHeight() / GetCVar("RenderScale"))
	
	print(screenHeight)
	rtbMainFrame:SetResizeBounds(screenWidth / 10, screenHeight / 12, screenWidth / 4, screenHeight / 3)
	--rtbResizeFrame(rtbMainFrame)

	rtbMainFrameBackdropInfo =
	{
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
		edgeFile = "Interface\\Glues\\Common\\TextPanel-Border",
		tileEdge = true,
		edgeSize = 16,
	}
	
	rtbMainFrame.backdropInfo = rtbMainFrameBackdropInfo  -- from FrameXML/Backdrop.lua
	rtbMainFrame:ApplyBackdrop()

	rtbResizeGrabber = CreateFrame("Frame", nil, rtbMainFrame)
	rtbResizeGrabber:SetPoint("BottomRight", rtbMainFrame, "BottomRight", 0, 0)
	rtbResizeGrabber:SetWidth(16)
	rtbResizeGrabber:SetHeight(16)
	rtbResizeGrabber:SetFrameLevel(rtbMainFrame:GetFrameLevel() + 7)
	rtbResizeGrabber:EnableMouse(true)

	local rtbResizeTexture = rtbResizeGrabber:CreateTexture(nil, "Artwork")
	rtbResizeTexture:SetPoint("TopLeft", rtbResizeGrabber, "TopLeft", 0, 0)
	rtbResizeTexture:SetWidth(16)
	rtbResizeTexture:SetHeight(16)
	rtbResizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")

	rtbMainFrame:SetResizable(true)
	rtbResizeGrabber:SetScript("OnEnter", function(self)
		rtbResizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	end)
	rtbResizeGrabber:SetScript("OnLeave", function(self)
		rtbResizeTexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	end)
	rtbResizeGrabber:SetScript("OnMouseDown", function(self, button)
		rtbMainFrame:StartSizing("BOTTOMRIGHT")
	end)
	rtbResizeGrabber:SetScript("OnMouseUp", function(self, button)
		rtbMainFrame:StopMovingOrSizing()
			
		eb:SetSize(rtbMainFrame:GetWidth() -35, rtbMainFrame:GetHeight())
	end)

	-- Close button
	rtbMainFrame.closeButton = CreateFrame("Button", "RTBClose", rtbMainFrame, "UIPanelCloseButton")
	rtbMainFrame.closeButton:ClearAllPoints()
	rtbMainFrame.closeButton:SetPoint("TOPRIGHT", rtbMainFrame, "TOPRIGHT", 0, 0)
	rtbMainFrame.closeButton:SetScript("OnClick",
		function()
			rtbCloseWindow()
		end
	)
	rtbMainFrame.closeButton:SetFrameLevel(4)

	rtbLock = CreateFrame("Button", "RTBLock", rtbMainFrame, "BackdropTemplate")

	backdropInfoLockUp = {
		bgFile = "Interface\\Buttons\\LockButton-Locked-Up"
	}

	backdropInfoUnlockUp = {
		bgFile = "Interface\\Buttons\\LockButton-Unlocked-Up"
	}

	backdropInfoUnlockDown = {
		bgFile = "Interface\\Buttons\\LockButton-Unlocked-Down"
	}

	rtbLock:SetSize(24, 24)
	rtbLock:SetPoint("TOPRIGHT", -rtbMainFrame.closeButton:GetWidth(), 0)
	rtbLock:SetScript("OnClick",
		function()
			if(rtbMainFrame:IsMouseEnabled()) then
				--rtbMainFrame:SetMovable(false)
				rtbMainFrame:EnableMouse(false)
				rtbLock.backdropInfo = backdropInfoLockUp
				locked = true
				
				rtbResizeGrabber:Hide()
				rtbSlider:Hide()
				dungeonDropMenu:Hide()
				rtbMainFrame.closeButton:Hide()
				rtbLock:ClearAllPoints()
				rtbLock:SetPoint("TOPLEFT", 0, 0)
				eb:Disable()
				
				rtbMainFrame:ClearBackdrop()
			else
				--rtbMainFrame:SetMovable(true)
				rtbMainFrame:EnableMouse(true)
				rtbLock.backdropInfo = backdropInfoUnlockUp
				locked = false
				
				rtbResizeGrabber:Show()
				rtbSlider:Show()
				dungeonDropMenu:Show()
				rtbMainFrame.closeButton:Show()
				rtbLock:ClearAllPoints()
				rtbLock:SetPoint("TOPRIGHT", -rtbMainFrame.closeButton:GetWidth(), 0)
				eb:Enable()
				
				rtbMainFrame.backdropInfo = rtbMainFrameBackdropInfo
				rtbMainFrame:ApplyBackdrop()
			end

			rtbLock:ApplyBackdrop()

		end
	)
	rtbLock:SetScript("OnMouseDown",
		function()
			rtbLock.backdropInfo = backdropInfoUnlockDown
			rtbLock:ApplyBackdrop()
		end
	)
	
	
	rtbMainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")	
	rtbMainFrame:RegisterEvent("PLAYER_LOGIN")
	rtbMainFrame:SetScript("OnEvent", OnEvent)
	
	rtbScrollFrame = CreateFrame("ScrollFrame", "RTBScrollFrame", rtbMainFrame, "UIPanelScrollFrameTemplate")
	rtbScrollFrame:SetPoint("TOPLEFT", 5, -30)
	rtbScrollFrame:SetPoint("BOTTOMRIGHT", -25, 20)
		
	rtbScrollChild = CreateFrame("Frame", "RTBScrollChild")
	rtbScrollChild:SetWidth(rtbScrollFrame:GetWidth())
	rtbScrollChild:SetHeight(1)
	
	rtbScrollFrame:SetScrollChild(rtbScrollChild)
	
	rtbSlider = _G[rtbScrollFrame:GetName() .. "ScrollBar"];
	
	-- EditBox
	eb = CreateFrame("EditBox", "RTBEditBox", rtbScrollChild)
	eb:SetSize(rtbMainFrame:GetWidth()-35, rtbMainFrame:GetHeight())
	eb:SetMultiLine(true)
	eb:SetAutoFocus(false) -- dont automatically focus
	eb:SetFontObject("ChatFontNormal")
	eb:SetPoint("TOPLEFT", 5, 0)
	eb:SetScript("OnEscapePressed", 
		function() --rtbMainFrame:Hide() 
			eb:ClearFocus()
		end
	)
	path, height, flags = eb:GetFont()
	eb:SetFont(path, 10, flags)
	eb:SetScript("OnTextChanged", 
		function() 
			key = UIDropDownMenu_GetSelectedValue(dungeonDropMenu)
			dungeonTexts[key] = eb:GetText()
		end
	)
	
	--[[local rb = CreateFrame("Button", "RTBResizeButton", rtbMainFrame)
	rb:SetPoint("BOTTOMRIGHT", -5, 7)
	rb:SetSize(16, 16)

	rb:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	rb:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	rb:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")

	rb:SetScript("OnMouseDown", function(self, button)
			if button == "LeftButton" then
				rtbMainFrame:StartSizing("BOTTOMRIGHT")
				self:GetHighlightTexture():Hide() -- more noticeable
			end
	end)
	rb:SetScript("OnMouseUp", function(self, button)
			rtbMainFrame:StopMovingOrSizing()
			self:GetHighlightTexture():Show()
			eb:SetWidth(rtbScrollFrame:GetWidth())
	end)
	
	rb:Hide()]]--
	
	--rtbMainFrame:Hide()
			
	instanceIDs = {
		1202, -- Ruby
		1198, -- Nok'Hud
		1203, -- Vault
		1201, -- Academy
		721, -- Halls
		800, -- Court
		313, -- Temple
		537, -- Shadowmoon
	}
		
 	dungeonDropMenu = CreateFrame("FRAME", "dungeonDropDown", rtbMainFrame, "UIDropDownMenuTemplate")
	dungeonDropMenu:SetPoint("TOPLEFT", -15, 0)
	dungeonDropMenu:SetFrameLevel(1000)
	UIDropDownMenu_SetWidth(dungeonDropMenu, 240-50)
	UIDropDownMenu_SetAnchor(dungeonDropMenu, 0, 20, "TOP", dungeonDropMenu, "BOTTOM")
				
	UIDropDownMenu_Initialize(dungeonDropMenu,
		function(self, level, menuList)
			info = UIDropDownMenu_CreateInfo()	
			if(menuList == nil) then
				menuList = 1
			end
			
			if(level == 1) then
				for i=1, 10, 1 do
					
					EJ_SelectTier(i)
										
					info.text = EJ_GetTierInfo(i)
					info.hasArrow = true	
					info.menuList = i	
					info.value = i
					info.arg1 = i
							
					info.checked = false
					UIDropDownMenu_AddButton(info, 1)
				end
			else	
				EJ_SelectTier(menuList)
				k = 1
				while(EJ_GetInstanceByIndex(k, false)) do	
					--print(EJ_GetCurrentTier())
					--journalID = select(1, EJ_GetInstanceByIndex(k, false))
					_, name, _, _, _, _, _, _, _, _, tempInstanceID = EJ_GetInstanceByIndex(k, false)
					
					info.func = self.SetValue
					info.text = name
					info.hasArrow = false
					info.value = tempInstanceID
					info.arg1 = tempInstanceID
					info.arg2 = name
					info.checked = tempInstanceID == lastDungeon
					
					--info.icon = icon
					
					UIDropDownMenu_AddButton(info, 2)
					
					k = k + 1
				end
			end
		end
	)
	
	function dungeonDropMenu:SetValue(dungeonID, name)
		tempText = dungeonTexts[dungeonID]
		
		if(tempText ~= nil) then
			eb:SetText(tempText)
		else
			eb:SetText("")
		end
		
		lastDungeon = dungeonID
		UIDropDownMenu_SetSelectedValue(dungeonDropMenu, dungeonID)
		UIDropDownMenu_SetText(dungeonDropMenu, name)
		
		CloseDropDownMenus()
	end
end

function rtbCreateBorder(self, thickness, r, g, b)	
	if(r == nil and g == nil and b == nil) then
		r = math.random()
		g = math.random()
		b = math.random()
	end
	rtbCalculateBorder(self, r, g, b, thickness)
end

function rtbCalculateBorder(self, r, g, b, thickness)
	if not self.borders then
        self.borders = {}
        for i=1, 4 do
            self.borders[i] = self:CreateLine(nil, "BACKGROUND", nil, 0)
            local l = self.borders[i]
            l:SetThickness(thickness)
            l:SetColorTexture(r, g, b, 1)
            if i==1 then
                l:SetStartPoint("TOPLEFT", self, -thickness+1, 0)
                l:SetEndPoint("TOPRIGHT")
            elseif i==2 then
                l:SetStartPoint("TOPRIGHT")
                l:SetEndPoint("BOTTOMRIGHT")
            elseif i==3 then
                l:SetStartPoint("BOTTOMRIGHT")
                l:SetEndPoint("BOTTOMLEFT", -thickness+1, 0)
            else
                l:SetStartPoint("BOTTOMLEFT")
                l:SetEndPoint("TOPLEFT")
            end
        end
    end
end

rtbInitializeFrames()