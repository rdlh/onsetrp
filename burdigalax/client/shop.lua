local BurdigalaxShop

function OnPackageStart()
	local width, height = GetScreenSize()
	--ZOrder = 5 and FrameRate = 10
	BurdigalaxShop = CreateWebUI(width / 4.7, height / 4.7, 540, -1050, 5, 60)
	--shop = CreateWebUI(850.0, 400.0, 800.0, 650.0, 5, 10)
    LoadWebFile(BurdigalaxShop, "http://asset/"..GetPackageName().."/client/gui/onShop.html")
	SetWebAlignment(BurdigalaxShop, 0.0, 0.0)
	SetWebAnchors(BurdigalaxShop, 0.0, 0.0, 1.0, 1.0)
	SetWebVisibility(BurdigalaxShop, WEB_HIDDEN)
end
AddEvent("OnPackageStart", OnPackageStart)

function OnPackageStop()
	DestroyWebUI(BurdigalaxShop)
end
AddEvent("OnPackageStop", OnPackageStop)

function CloseUI()
    ExecuteWebJS(BurdigalaxShop, "ResetBasket()")
    SetIgnoreLookInput(false)
    SetIgnoreMoveInput(false)
    ShowMouseCursor(false)
    SetInputMode(INPUT_GAME)
    Delay(100, function()
    	SetWebVisibility(BurdigalaxShop, WEB_HIDDEN)
    end)
end
AddEvent("BURDIGALAX_onShop_onClose", CloseUI)

function OpenUI()
    ExecuteWebJS(BurdigalaxShop, "SetConfig()")
    SetIgnoreLookInput(true)
    SetIgnoreMoveInput(true)
    ShowMouseCursor(true)
    SetInputMode(INPUT_GAMEANDUI)
    SetWebVisibility(BurdigalaxShop, WEB_VISIBLE)
end

function OnKeyPress(key)
	if key == "B" then
        local visibility = GetWebVisibility(BurdigalaxShop)
        if visibility == WEB_HIDDEN then
            OpenUI()
        end
        if visibility == WEB_VISIBLE then
            CloseUI()
        end
    end
end
AddEvent("OnKeyPress", OnKeyPress)

function OnPayment(event)
    local test = json_decode(event)
    if test.type == "cash" then
       ExecuteWebJS(BurdigalaxShop, "SetSuccess()")
    else
       ExecuteWebJS(BurdigalaxShop, "SetError()")
    end
end
AddEvent('BURDIGALAX_onShop_onContactLessPayment', OnPayment)
AddEvent('BURDIGALAX_onShop_onCashPayment', OnPayment)
AddEvent('BURDIGALAX_onShop_onCardPayment', OnPayment)