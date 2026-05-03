local _bqriJZa = game:GetService("HttpService")
local _z03GmnY = game:GetService("StarterGui")
local _rabFkk3 = game:GetService("TweenService")
local _nJ4UgTL = game:GetService("Players")
local _KbMLLIt = game:GetService("UserInputService")
local _ohivvSj = "https://api.kodamo.net/api"
local _htqnyRJ = "f7c66319-15bd-4a7f-aa90-acc3760d64dc"
local REQUIRE_KEY = false
local _KYNj1WN = tostring(game.GameId)
local _ZO7qHbp = "3612e8430df53679071a10ce662f91ec"
local function _SB3IyYB(_ULkJqvC)
    return _bqriJZa:UrlEncode(_ULkJqvC)
end
local function _KO5QkrB(_Uq3pFMb, _ut4feSl, _KD4Bh13)
    pcall(function()
        _z03GmnY:SetCore("SendNotification", {
            ["Title"] = _Uq3pFMb or "Jade.xyz beta",
            ["Text"] = _ut4feSl or "",
            ["Duration"] = _KD4Bh13 or 3
        })
    end)
end
local _KcW1dyQ = script_key and script_key ~= ""
if REQUIRE_KEY and not _KcW1dyQ then
    _hnEKI4W()
    return
end
_KO5QkrB("Jade.xyz beta", "Loading...", 2)
local function _wd6TOZa(_FCW4PLl, _BMcIfO5)
    _BMcIfO5 = _BMcIfO5 or 3
    for _RGwoAkt = 1, _BMcIfO5 do
        local _ITsXuRS, _iY1GOaD = pcall(function()
            return game:HttpGet(_FCW4PLl)
        end)
        if _ITsXuRS and _iY1GOaD then return true, _iY1GOaD end
        if _RGwoAkt < _BMcIfO5 then task.wait(0.5 * _RGwoAkt) end
    end
    return false, nil
end
local function _q0d4pkj()
    local _ITsXuRS, _iY1GOaD = _wd6TOZa(_ohivvSj .. "/scripts/verify/" .. _htqnyRJ .. "?gameId=" .. _KYNj1WN)
    if not _ITsXuRS then return false end
    local _PQXEBef, _aFoarbg = pcall(function() return _bqriJZa:JSONDecode(_iY1GOaD) end)
    if not _PQXEBef or not _aFoarbg.supported then return false end
    return true, _aFoarbg
end
local function _zmxErb6()
    local _ITsXuRS, _iY1GOaD = _wd6TOZa(_ohivvSj .. "/keys/validate/" .. _SB3IyYB(script_key))
    if not _ITsXuRS then return false end
    local _PQXEBef, _aFoarbg = pcall(function() return _bqriJZa:JSONDecode(_iY1GOaD) end)
    if not _PQXEBef or not _aFoarbg.valid then
        _KO5QkrB("Jade.xyz beta", _aFoarbg and _aFoarbg.error or "Invalid key", 5)
        return false
    end
    return true, _aFoarbg
end
local function _phKW7cH()
    local _ITsXuRS, _iY1GOaD = pcall(function()
        return game:HttpGet("https://api.ipify.org")
    end)
    if _ITsXuRS and _iY1GOaD and #_iY1GOaD < 50 then return _iY1GOaD end
    return nil
end
local function _qqAf3VB()
    local _FCW4PLl
    if _KcW1dyQ then
        _FCW4PLl = _ohivvSj .. "/keys/" .. _SB3IyYB(script_key) .. "/versions?gameId=" .. _KYNj1WN
    else
        _FCW4PLl = _ohivvSj .. "/keys/free/" .. _htqnyRJ .. "/versions?gameId=" .. _KYNj1WN
    end
    local _ITsXuRS, _iY1GOaD = _wd6TOZa(_FCW4PLl)
    if not _ITsXuRS then return nil end
    local _PQXEBef, _aFoarbg = pcall(function() return _bqriJZa:JSONDecode(_iY1GOaD) end)
    if not _PQXEBef or not _aFoarbg.versions then return nil end
    return _aFoarbg.versions
end
local playerName = game.Players.LocalPlayer and game.Players.LocalPlayer.Name or nil
local function _HqZZP2W(_hS9hJ2A, _YvbNp0b)
    local _FCW4PLl
    if _KcW1dyQ then
        _FCW4PLl = _ohivvSj .. "/keys/" .. _SB3IyYB(script_key) .. "/script?gameId=" .. _KYNj1WN
    else
        _FCW4PLl = _ohivvSj .. "/keys/free/" .. _htqnyRJ .. "/script?gameId=" .. _KYNj1WN
    end
    if _YvbNp0b then _FCW4PLl = _FCW4PLl .. "&versionId=" .. _SB3IyYB(_YvbNp0b) end
    if _hS9hJ2A then _FCW4PLl = _FCW4PLl .. "&hwid=" .. _SB3IyYB(_hS9hJ2A) end
    if playerName then _FCW4PLl = _FCW4PLl .. "&cn=" .. _SB3IyYB(playerName) end
    _FCW4PLl = _FCW4PLl .. "&lt=" .. _SB3IyYB(_ZO7qHbp)
    local _ITsXuRS, _iY1GOaD = _wd6TOZa(_FCW4PLl)
    if not _ITsXuRS then return nil, "Request failed" end
    if _iY1GOaD:sub(1, 2) == "--" then
        return nil, _iY1GOaD:match("^-- Error: (.+)") or "Unknown error"
    end
    return _iY1GOaD, nil
end
local function _QdzguNw(_FCW4PLl)
    local _ITsXuRS, _iY1GOaD = pcall(function()
        return game:HttpGet(_FCW4PLl)
    end)
    if not _ITsXuRS then return nil end
    return _iY1GOaD
end
local function _efsewFg(_eVFPAqW)
    local _GW05jxV = nil
    local _HoLI74T = false
    local _mIFtidw = {
        Bg = Color3.fromRGB(10, 10, 15),
        ["Card"] = Color3.fromRGB(21, 21, 31),
        Border = Color3.fromRGB(138, 43, 226),
        Purple = Color3.fromRGB(138, 43, 226),
        Cyan = Color3.fromRGB(0, 255, 255),
        Green = Color3.fromRGB(0, 255, 127),
        Yellow = Color3.fromRGB(255, 215, 0),
        Pink = Color3.fromRGB(255, 50, 120),
        Text = Color3.fromRGB(245, 245, 255),
        TextMuted = Color3.fromRGB(140, 140, 170),
        InputBg = Color3.fromRGB(15, 15, 22)
    }
    local _zE9KWUY = {
        [0] = _mIFtidw.TextMuted,
        [1] = Color3.fromRGB(96, 165, 250),
        [2] = _mIFtidw.Purple,
        [3] = _mIFtidw.Yellow,
        [4] = _mIFtidw.Cyan,
        [5] = _mIFtidw.Green,
    }
    local function _xVY6gJ3(_x67F6XS)
        return _zE9KWUY[_x67F6XS] or _zE9KWUY[5]
    end
    local _txeDJn3 = Instance.new("ScreenGui")
    _txeDJn3.Name = "KodamoVersionSelector"
    _txeDJn3.ResetOnSpawn = false
    _txeDJn3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    _txeDJn3.DisplayOrder = 999
    _txeDJn3.IgnoreGuiInset = true
    local _CO2XqaE = Instance.new("Frame")
    _CO2XqaE.Name = "Backdrop"
    _CO2XqaE.Size = UDim2.new(1, 0, 1, 0)
    _CO2XqaE.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    _CO2XqaE.BackgroundTransparency = 0.4
    _CO2XqaE.BorderSizePixel = 0
    _CO2XqaE.Parent = _txeDJn3
    local _bu6OtUy = Instance.new("Frame")
    _bu6OtUy.Name = "Container"
    _bu6OtUy.Size = UDim2.new(0, 440, 0, 0)
    _bu6OtUy.Position = UDim2.new(0.5, 0, 0.5, 0)
    _bu6OtUy.AnchorPoint = Vector2.new(0.5, 0.5)
    _bu6OtUy.BackgroundColor3 = _mIFtidw["Card"]
    _bu6OtUy.BorderSizePixel = 0
    _bu6OtUy.ClipsDescendants = true
    _bu6OtUy.Active = true
    _bu6OtUy.Parent = _txeDJn3
    local _pS3PGJb = Instance.new("UICorner")
    _pS3PGJb.CornerRadius = UDim.new(0, 16)
    _pS3PGJb.Parent = _bu6OtUy
    local _xfuvcPt = Instance.new("UIStroke")
    _xfuvcPt.Color = _mIFtidw.Border
    _xfuvcPt.Thickness = 1.5
    _xfuvcPt.Transparency = 0.3
    _xfuvcPt.Parent = _bu6OtUy
    local _i9Ibm2p = Instance.new("ImageLabel")
    _i9Ibm2p.Size = UDim2.new(1, 50, 1, 50)
    _i9Ibm2p.Position = UDim2.new(0.5, 0, 0.5, 5)
    _i9Ibm2p.AnchorPoint = Vector2.new(0.5, 0.5)
    _i9Ibm2p.BackgroundTransparency = 1
    _i9Ibm2p.Image = "rbxassetid://6014261993"
    _i9Ibm2p.ImageColor3 = _mIFtidw.Purple
    _i9Ibm2p.ImageTransparency = 0.85
    _i9Ibm2p.ScaleType = Enum.ScaleType.Slice
    _i9Ibm2p.SliceCenter = Rect.new(49, 49, 450, 450)
    _i9Ibm2p.ZIndex = -1
    _i9Ibm2p.Parent = _bu6OtUy
    local _H02BZap = Instance.new("Frame")
    _H02BZap.Name = "Header"
    _H02BZap.Size = UDim2.new(1, 0, 0, 64)
    _H02BZap.BackgroundColor3 = _mIFtidw.Bg
    _H02BZap.BackgroundTransparency = 0.5
    _H02BZap.BorderSizePixel = 0
    _H02BZap.Parent = _bu6OtUy
    local _kF4ULrM = Instance.new("UICorner")
    _kF4ULrM.CornerRadius = UDim.new(0, 16)
    _kF4ULrM.Parent = _H02BZap
    local _t6d8auy = Instance.new("Frame")
    _t6d8auy.Size = UDim2.new(1, 0, 0, 16)
    _t6d8auy.Position = UDim2.new(0, 0, 1, -16)
    _t6d8auy.BackgroundColor3 = _H02BZap.BackgroundColor3
    _t6d8auy.BackgroundTransparency = _H02BZap.BackgroundTransparency
    _t6d8auy.BorderSizePixel = 0
    _t6d8auy.Parent = _H02BZap
    local _Gw3YQhf = Instance.new("TextLabel")
    _Gw3YQhf.Size = UDim2.new(1, -80, 0, 24)
    _Gw3YQhf.Position = UDim2.new(0, 24, 0, 12)
    _Gw3YQhf.BackgroundTransparency = 1
    _Gw3YQhf.Text = "Jade.xyz beta"
    _Gw3YQhf.TextColor3 = _mIFtidw.Cyan
    _Gw3YQhf.Font = Enum.Font.GothamBold
    _Gw3YQhf.TextSize = 20
    _Gw3YQhf.TextXAlignment = Enum.TextXAlignment.Left
    _Gw3YQhf.Parent = _H02BZap
    local _aXL0dZp = Instance.new("TextLabel")
    _aXL0dZp.Size = UDim2.new(0, 250, 0, 18)
    _aXL0dZp.Position = UDim2.new(0, 24, 0, 38)
    _aXL0dZp.BackgroundTransparency = 1
    _aXL0dZp.Text = "Select Version"
    _aXL0dZp.TextColor3 = _mIFtidw.TextMuted
    _aXL0dZp.Font = Enum.Font.Gotham
    _aXL0dZp.TextSize = 14
    _aXL0dZp.TextXAlignment = Enum.TextXAlignment.Left
    _aXL0dZp.Parent = _H02BZap
    local _Si7Ydn7 = Instance.new("TextButton")
    _Si7Ydn7.Size = UDim2.new(0, 36, 0, 36)
    _Si7Ydn7.Position = UDim2.new(1, -50, 0, 14)
    _Si7Ydn7.BackgroundColor3 = _mIFtidw.InputBg
    _Si7Ydn7.BorderSizePixel = 0
    _Si7Ydn7.Text = "X"
    _Si7Ydn7.TextColor3 = _mIFtidw.TextMuted
    _Si7Ydn7.Font = Enum.Font.GothamBold
    _Si7Ydn7.TextSize = 16
    _Si7Ydn7.AutoButtonColor = false
    _Si7Ydn7.Parent = _H02BZap
    local _VmovhYH = Instance.new("UICorner")
    _VmovhYH.CornerRadius = UDim.new(0, 8)
    _VmovhYH.Parent = _Si7Ydn7
    _Si7Ydn7.MouseEnter:Connect(function()
        _rabFkk3:Create(_Si7Ydn7, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(239, 68, 68)}):Play()
        _rabFkk3:Create(_Si7Ydn7, TweenInfo.new(0.15), {TextColor3 = _mIFtidw.Text}):Play()
    end)
    _Si7Ydn7.MouseLeave:Connect(function()
        _rabFkk3:Create(_Si7Ydn7, TweenInfo.new(0.15), {BackgroundColor3 = _mIFtidw.InputBg}):Play()
        _rabFkk3:Create(_Si7Ydn7, TweenInfo.new(0.15), {TextColor3 = _mIFtidw.TextMuted}):Play()
    end)
    local _NIBtmo9 = Instance.new("ScrollingFrame")
    _NIBtmo9.Name = "List"
    _NIBtmo9.Size = UDim2.new(1, -32, 1, -78)
    _NIBtmo9.Position = UDim2.new(0, 16, 0, 70)
    _NIBtmo9.BackgroundTransparency = 1
    _NIBtmo9.BorderSizePixel = 0
    _NIBtmo9.ScrollBarThickness = 5
    _NIBtmo9.ScrollBarImageColor3 = _mIFtidw.Purple
    _NIBtmo9.CanvasSize = UDim2.new(0, 0, 0, 0)
    _NIBtmo9.AutomaticCanvasSize = Enum.AutomaticSize.Y
    _NIBtmo9.Parent = _bu6OtUy
    local _HPbVPvL = Instance.new("UIListLayout")
    _HPbVPvL.SortOrder = Enum.SortOrder.LayoutOrder
    _HPbVPvL.Padding = UDim.new(0, 10)
    _HPbVPvL.Parent = _NIBtmo9
    local _t3mXEM2 = Instance.new("UIPadding")
    _t3mXEM2.PaddingBottom = UDim.new(0, 16)
    _t3mXEM2.Parent = _NIBtmo9
    for _RGwoAkt, _yDZViMG in ipairs(_eVFPAqW) do
        local _V4I1o8j = _yDZViMG.tierLevel or 0
        local _oqbYmLa = _xVY6gJ3(_V4I1o8j)
        local _j4nr4oe = Instance.new("TextButton")
        _j4nr4oe.Name = "Version_" .. _RGwoAkt
        _j4nr4oe.Size = UDim2.new(1, -4, 0, 72)
        _j4nr4oe.BackgroundColor3 = _mIFtidw.InputBg
        _j4nr4oe.BorderSizePixel = 0
        _j4nr4oe.Text = ""
        _j4nr4oe.AutoButtonColor = false
        _j4nr4oe.LayoutOrder = _RGwoAkt
        _j4nr4oe.Parent = _NIBtmo9
        local _DGP6hF4 = Instance.new("UICorner")
        _DGP6hF4.CornerRadius = UDim.new(0, 12)
        _DGP6hF4.Parent = _j4nr4oe
        local _IIdXGPw = Instance.new("UIStroke")
        _IIdXGPw.Color = _mIFtidw.Border
        _IIdXGPw.Thickness = 1
        _IIdXGPw.Transparency = 0.7
        _IIdXGPw.Parent = _j4nr4oe
        local _EsbnBNh = Instance.new("Frame")
        _EsbnBNh.Size = UDim2.new(0, 5, 0.55, 0)
        _EsbnBNh.Position = UDim2.new(0, 14, 0.225, 0)
        _EsbnBNh.BackgroundColor3 = _oqbYmLa
        _EsbnBNh.BorderSizePixel = 0
        _EsbnBNh.Parent = _j4nr4oe
        local _Vf5R0Sc = Instance.new("UICorner")
        _Vf5R0Sc.CornerRadius = UDim.new(0, 3)
        _Vf5R0Sc.Parent = _EsbnBNh
        local _nqiSH4h = Instance.new("TextLabel")
        _nqiSH4h.Size = UDim2.new(1, -120, 0, 24)
        _nqiSH4h.Position = UDim2.new(0, 30, 0, 12)
        _nqiSH4h.BackgroundTransparency = 1
        _nqiSH4h.Text = _yDZViMG.name or _yDZViMG.tierName or ("Version " .. _RGwoAkt)
        _nqiSH4h.TextColor3 = _mIFtidw.Text
        _nqiSH4h.Font = Enum.Font.GothamBold
        _nqiSH4h.TextSize = 17
        _nqiSH4h.TextXAlignment = Enum.TextXAlignment.Left
        _nqiSH4h.TextTruncate = Enum.TextTruncate.AtEnd
        _nqiSH4h.Parent = _j4nr4oe
        local _Usew7iA = Instance.new("TextLabel")
        _Usew7iA.Size = UDim2.new(1, -120, 0, 18)
        _Usew7iA.Position = UDim2.new(0, 30, 0, 38)
        _Usew7iA.BackgroundTransparency = 1
        _Usew7iA.Text = (_yDZViMG.tierName or "Free") .. " - Level " .. _V4I1o8j
        _Usew7iA.TextColor3 = _mIFtidw.TextMuted
        _Usew7iA.Font = Enum.Font.Gotham
        _Usew7iA.TextSize = 13
        _Usew7iA.TextXAlignment = Enum.TextXAlignment.Left
        _Usew7iA.Parent = _j4nr4oe
        local _yOqISvm = Instance.new("Frame")
        _yOqISvm.Size = UDim2.new(0, 74, 0, 30)
        _yOqISvm.Position = UDim2.new(1, -88, 0.5, -15)
        _yOqISvm.BackgroundColor3 = _oqbYmLa
        _yOqISvm.BackgroundTransparency = 0.85
        _yOqISvm.BorderSizePixel = 0
        _yOqISvm.Parent = _j4nr4oe
        local _po5CRXf = Instance.new("UICorner")
        _po5CRXf.CornerRadius = UDim.new(0, 8)
        _po5CRXf.Parent = _yOqISvm
        local _LILLPkI = Instance.new("UIStroke")
        _LILLPkI.Color = _oqbYmLa
        _LILLPkI.Thickness = 1
        _LILLPkI.Transparency = 0.5
        _LILLPkI.Parent = _yOqISvm
        local _JOGYZP5 = Instance.new("TextLabel")
        _JOGYZP5.Size = UDim2.new(1, 0, 1, 0)
        _JOGYZP5.BackgroundTransparency = 1
        _JOGYZP5.Text = _V4I1o8j == 0 and "FREE" or ("LVL " .. _V4I1o8j)
        _JOGYZP5.TextColor3 = _oqbYmLa
        _JOGYZP5.Font = Enum.Font.GothamBold
        _JOGYZP5.TextSize = 13
        _JOGYZP5.Parent = _yOqISvm
        _j4nr4oe.MouseEnter:Connect(function()
            _rabFkk3:Create(_IIdXGPw, TweenInfo.new(0.2), {Color = _oqbYmLa, Transparency = 0}):Play()
            _rabFkk3:Create(_j4nr4oe, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(
                math.min(255, _mIFtidw.InputBg.R * 255 + 8),
                math.min(255, _mIFtidw.InputBg.G * 255 + 8),
                math.min(255, _mIFtidw.InputBg.B * 255 + 12)
            )}):Play()
        end)
        _j4nr4oe.MouseLeave:Connect(function()
            _rabFkk3:Create(_IIdXGPw, TweenInfo.new(0.2), {Color = _mIFtidw.Border, Transparency = 0.7}):Play()
            _rabFkk3:Create(_j4nr4oe, TweenInfo.new(0.2), {BackgroundColor3 = _mIFtidw.InputBg}):Play()
        end)
        _j4nr4oe.MouseButton1Click:Connect(function()
            _rabFkk3:Create(_IIdXGPw, TweenInfo.new(0.1), {Color = _mIFtidw.Green, Transparency = 0}):Play()
            _rabFkk3:Create(_j4nr4oe, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 255, 127)}):Play()
            _rabFkk3:Create(_nqiSH4h, TweenInfo.new(0.1), {TextColor3 = Color3.fromRGB(10, 10, 15)}):Play()
            task.wait(0.15)
            _GW05jxV = _yDZViMG.id
            _HoLI74T = true
        end)
    end
    _Si7Ydn7.MouseButton1Click:Connect(function()
        _HoLI74T = true
    end)
    _CO2XqaE.InputBegan:Connect(function(_hxavNby)
        if _hxavNby.UserInputType == Enum.UserInputType.MouseButton1 or _hxavNby.UserInputType == Enum.UserInputType.Touch then
            _HoLI74T = true
        end
    end)
    local _h0Z5xoj, _saV2j8S, _HPjcWWH
    _H02BZap.InputBegan:Connect(function(_hxavNby)
        if _hxavNby.UserInputType == Enum.UserInputType.MouseButton1 or _hxavNby.UserInputType == Enum.UserInputType.Touch then
            _h0Z5xoj = true
            _saV2j8S = _hxavNby.Position
            _HPjcWWH = _bu6OtUy.Position
        end
    end)
    _H02BZap.InputEnded:Connect(function(_hxavNby)
        if _hxavNby.UserInputType == Enum.UserInputType.MouseButton1 or _hxavNby.UserInputType == Enum.UserInputType.Touch then
            _h0Z5xoj = false
        end
    end)
    _KbMLLIt.InputChanged:Connect(function(_hxavNby)
        if _h0Z5xoj and (_hxavNby.UserInputType == Enum.UserInputType.MouseMovement or _hxavNby.UserInputType == Enum.UserInputType.Touch) then
            local _sPo7vqe = _hxavNby.Position - _saV2j8S
            _bu6OtUy.Position = UDim2.new(_HPjcWWH.X.Scale, _HPjcWWH.X.Offset + _sPo7vqe.X, _HPjcWWH.Y.Scale, _HPjcWWH.Y.Offset + _sPo7vqe.Y)
        end
    end)
    local _uQGcUuN = 72 + 10
    local _KqBzYiS = math.min(#_eVFPAqW, 5)
    local _mtHOs1X = _KqBzYiS * _uQGcUuN + 16
    local _PClBa6I = 70 + _mtHOs1X + 20
    _bu6OtUy.BackgroundTransparency = 1
    _xfuvcPt.Transparency = 1
    _CO2XqaE.BackgroundTransparency = 1
    _txeDJn3.Parent = _nJ4UgTL.LocalPlayer:WaitForChild("PlayerGui")
    _rabFkk3:Create(_CO2XqaE, TweenInfo.new(0.3), {BackgroundTransparency = 0.4}):Play()
    _rabFkk3:Create(_bu6OtUy, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 440, 0, _PClBa6I),
        BackgroundTransparency = 0
    }):Play()
    _rabFkk3:Create(_xfuvcPt, TweenInfo.new(0.35), {Transparency = 0.3}):Play()
    while not _HoLI74T do
        task.wait(0.05)
    end
    _rabFkk3:Create(_bu6OtUy, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 440, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    _rabFkk3:Create(_CO2XqaE, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.wait(0.25)
    _txeDJn3:Destroy()
    return _GW05jxV
end
_KO5QkrB("Jade.xyz beta", "Checking game support...", 2)
local _hMEpbbz, _wtWQYy1 = _q0d4pkj()
if not _hMEpbbz then
    _KO5QkrB("Jade.xyz beta", "Game not supported", 5)
    return
end
local _hS9hJ2A = _phKW7cH()
if _KcW1dyQ then
    _KO5QkrB("Jade.xyz beta", "Validating key...", 2)
    local _BOVBQHC, _IHhlW0F = _zmxErb6()
    if not _BOVBQHC then return end
else
    _KO5QkrB("Jade.xyz beta", "Loading free versions...", 2)
end
local _OOOuD8e = _qqAf3VB()
if not _OOOuD8e or #_OOOuD8e == 0 then
    _KO5QkrB("Jade.xyz beta", "No versions available", 5)
    return
end
local _r9CTbxV
if #_OOOuD8e == 1 then
    _r9CTbxV = _OOOuD8e[1].id
else
    _r9CTbxV = _efsewFg(_OOOuD8e)
    if not _r9CTbxV then return end
end
if _KcW1dyQ then
    local _BOVBQHC = _zmxErb6()
    if not _BOVBQHC then return end
end
_KO5QkrB("Jade.xyz beta", "Loading script...", 2)
local _PQxJs4U, _Q70TKLg = _HqZZP2W(_hS9hJ2A, _r9CTbxV)
if not _PQxJs4U then
    _KO5QkrB("Jade.xyz beta", _Q70TKLg or "Failed to get script", 5)
    return
end
local _pMhJNmZ = _QdzguNw(_PQxJs4U)
if not _pMhJNmZ or (_pMhJNmZ:sub(1, 2) == "--" and _pMhJNmZ:find("Error")) then
    _KO5QkrB("Jade.xyz beta", "Failed to load script, contact support", 5)
    return
end
local _QtuCTIu = loadstring or getfenv().loadstring or (getgenv and getgenv().loadstring)
if not _QtuCTIu then
    _KO5QkrB("Jade.xyz beta", "Executor not supported", 5)
    return
end
local _DIjco9m, _w6QCrwx = _QtuCTIu(_pMhJNmZ)
if _DIjco9m then
    _KO5QkrB("Jade.xyz beta", "Script loaded!", 3)
    pcall(_DIjco9m)
else
    _KO5QkrB("Jade.xyz beta", "Execution error: " .. tostring(_w6QCrwx), 5)
end
if _KcW1dyQ and script_key and script_key:sub(1, 3) == "PK-" then
    task.spawn(function()
        local player = game.Players.LocalPlayer
        while player and player.Parent do
            task.wait(30)
            pcall(function()
                local body = _bqriJZa:JSONEncode({ key = script_key, _hS9hJ2A = _hS9hJ2A, cn = playerName })
                local _PQXEBef, resp = pcall(function()
                    return game:HttpPost(_ohivvSj .. "/sessions/heartbeat", body, false, "application/json")
                end)
                if _PQXEBef and resp then
                    pcall(function()
                        local d = _bqriJZa:JSONDecode(resp)
                        if d and d.ok == false and d.error == "CONCURRENT_LIMIT_REACHED" then
                            player:Kick("[Jade.xyz beta] Concurrent session limit reached: " .. tostring(d.concurrent.current) .. "/" .. tostring(d.concurrent.limit))
                        end
                    end)
                end
            end)
        end
    end)
end
