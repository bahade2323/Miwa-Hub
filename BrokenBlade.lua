if _G.BahadeHubShutdown then 
    pcall(_G.BahadeHubShutdown) 
    _G.BahadeHubShutdown = nil
    task.wait(0.1)
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "Miwa Hub"
Junkie.identifier = "1141330"
Junkie.provider = "Miwa Hub | Work.Ink"

local result = (function()
    getgenv().UI_CLOSED = false
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Lighting = game:GetService("Lighting")

    local Colors = {
        background = Color3.fromRGB(30, 31, 34),
        surface = Color3.fromRGB(43, 45, 49),
        surfaceLight = Color3.fromRGB(49, 51, 56),
        primary = Color3.fromRGB(88, 101, 242),
        primaryDark = Color3.fromRGB(71, 82, 196),
        primaryGlow = Color3.fromRGB(114, 137, 218),
        accent = Color3.fromRGB(88, 101, 242),
        success = Color3.fromRGB(35, 165, 90),
        successDark = Color3.fromRGB(28, 132, 72),
        successGlow = Color3.fromRGB(59, 201, 118),
        error = Color3.fromRGB(242, 63, 67),
        textPrimary = Color3.fromRGB(242, 243, 245),
        textSecondary = Color3.fromRGB(181, 186, 193),
        textMuted = Color3.fromRGB(148, 155, 164),
        border = Color3.fromRGB(30, 31, 34),
        borderLight = Color3.fromRGB(56, 58, 64),
        glass = Color3.fromRGB(255, 255, 255),
        neonBlue = Color3.fromRGB(88, 101, 242),
        neonPurple = Color3.fromRGB(120, 105, 250)
    }

    local function hasFileSystemSupport()
        local hasWritefile = pcall(function() return type(writefile) == "function" end)
        local hasReadfile = pcall(function() return type(readfile) == "function" end)
        local hasIsfile = pcall(function() return type(isfile) == "function" end)
        return hasWritefile and hasReadfile and hasIsfile
    end

    local fileSystemSupported = hasFileSystemSupport()

    local function saveVerifiedKey(key)
        if not fileSystemSupported then return false end
        local ok = pcall(function()
            writefile("Miwa Hub Key.txt", key)
        end)
        return ok
    end

    local function loadVerifiedKey()
        if not fileSystemSupported then
            return nil
        end

        local ok, content = pcall(function()
            return readfile("Miwa Hub Key.txt")
        end)

        if not ok or not content then
            return nil
        end
        return content
    end

    local function clearSavedKey()
        if not fileSystemSupported then return false end
        local ok = pcall(function() delfile("Miwa Hub Key.txt") end)
        return ok
    end

    local function loadUIFactory()
        return function(Colors, Players, TweenService, UserInputService, Lighting)
            local IconAssets = {
                minimize = 7072718362,
                x = 73070135088117,
                key = 128426502701541,
                link = 73034596791310,
                check = 83827110621355
            }

            local function createIconImage(name, size, color)
                local id = IconAssets[name]
                if id then
                    local img = Instance.new("ImageLabel")
                    img.BackgroundTransparency = 1
                    img.Size = UDim2.new(0, size or 18, 0, size or 18)
                    img.Image = "rbxassetid://" .. tostring(id)
                    img.ImageColor3 = color or Color3.fromRGB(255, 255, 255)
                    img.ScaleType = Enum.ScaleType.Fit
                    if img:IsA("ImageLabel") and img.ResampleMode ~= nil then
                        img.ResampleMode = Enum.ResamplerMode.Default
                    end
                    return img
                end

                local lbl = Instance.new("TextLabel")
                lbl.BackgroundTransparency = 1
                lbl.Size = UDim2.new(0, size or 18, 0, size or 18)
                lbl.TextScaled = true
                lbl.Font = Enum.Font.SourceSansBold
                lbl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
                lbl.Text = ({ minimize = "🗕", key = "🔑", link = "🔗", x = "X", check = "✓" })[name] or "🔘"
                return lbl
            end

            return function(self)
                if self.gui then
                    self.gui:Destroy()
                end

                self.gui = Instance.new("ScreenGui")
                self.gui.Name = "Miwa Hub | Key System"
                self.gui.ResetOnSpawn = false
                self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                self.gui.IgnoreGuiInset = true

                local backdrop = Instance.new("Frame")
                backdrop.Name = "Backdrop"
                backdrop.Size = UDim2.new(1, 0, 1, 0)
                backdrop.Position = UDim2.new(0, 0, 0, 0)
                backdrop.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                backdrop.BackgroundTransparency = 0.5
                backdrop.BorderSizePixel = 0
                backdrop.Parent = self.gui

                local blur = Instance.new("BlurEffect")
                blur.Size = 12
                blur.Name = "JunkieUIBlur"
                blur.Parent = Lighting

                local container = Instance.new("Frame")
                container.Name = "Container"

                local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
                local viewportSize = workspace.CurrentCamera.ViewportSize

                if isMobile then
                    container.Size = UDim2.new(0.6, 0, 0, math.min(320, viewportSize.Y * 0.8))
                    container.Position = UDim2.new(0.5, 0, 0.5, 0)
                    container.AnchorPoint = Vector2.new(0.5, 0.5)
                else
                    container.Size = UDim2.new(0, 580, 0, 320)
                    container.Position = UDim2.new(0.5, 0, 0.5, 0)
                    container.AnchorPoint = Vector2.new(0.5, 0.5)
                end

                container.BackgroundColor3 = Colors.surface
                container.BorderSizePixel = 0
                container.Parent = backdrop

                container:SetAttribute("IsMobile", isMobile)

                local containerCorner = Instance.new("UICorner")
                containerCorner.CornerRadius = UDim.new(0, 8)
                containerCorner.Parent = container

                local containerStroke = Instance.new("UIStroke")
                containerStroke.Color = Colors.borderLight
                containerStroke.Thickness = 1
                containerStroke.Transparency = 0.6
                containerStroke.Parent = container

                local shadow = Instance.new("Frame")
                shadow.Name = "Shadow"
                shadow.Size = UDim2.new(1, 20, 1, 20)
                shadow.Position = UDim2.new(0.5, 0, 0.5, 4)
                shadow.AnchorPoint = Vector2.new(0.5, 0.5)
                shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                shadow.BackgroundTransparency = 0.6
                shadow.BorderSizePixel = 0
                shadow.ZIndex = 0
                shadow.Parent = backdrop

                local shadowCorner = Instance.new("UICorner")
                shadowCorner.CornerRadius = UDim.new(0, 10)
                shadowCorner.Parent = shadow

                local glowFrame = Instance.new("Frame")
                glowFrame.Name = "GlowEffect"
                glowFrame.Size = UDim2.new(1, 40, 1, 40)
                glowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
                glowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                glowFrame.BackgroundColor3 = Colors.primary
                glowFrame.BackgroundTransparency = 0.96
                glowFrame.BorderSizePixel = 0
                glowFrame.ZIndex = -1
                glowFrame.Parent = backdrop

                local glowCorner = Instance.new("UICorner")
                glowCorner.CornerRadius = UDim.new(0, 16)
                glowCorner.Parent = glowFrame

                local glowTween = TweenService:Create(glowFrame,
                    TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    {BackgroundTransparency = 0.92, Size = UDim2.new(1, 55, 1, 55)}
                )
                glowTween:Play()

                local glassOverlay = Instance.new("Frame")
                glassOverlay.Name = "GlassOverlay"
                glassOverlay.Size = UDim2.new(1, 0, 1, 0)
                glassOverlay.Position = UDim2.new(0, 0, 0, 0)
                glassOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                glassOverlay.BackgroundTransparency = 0.99
                glassOverlay.BorderSizePixel = 0
                glassOverlay.ZIndex = 1
                glassOverlay.Parent = container

                local glassCorner = Instance.new("UICorner")
                glassCorner.CornerRadius = UDim.new(0, 8)
                glassCorner.Parent = glassOverlay

                local topBar = Instance.new("Frame")
                topBar.Name = "TopBar"
                topBar.Size = UDim2.new(1, 0, 0, 45)
                topBar.Position = UDim2.new(0, 0, 0, 0)
                topBar.BackgroundColor3 = Colors.background
                topBar.BorderSizePixel = 0
                topBar.ZIndex = 10
                topBar.Parent = container

                local topBarCorner = Instance.new("UICorner")
                topBarCorner.CornerRadius = UDim.new(0, 8)
                topBarCorner.Parent = topBar

                local topBarFix = Instance.new("Frame")
                topBarFix.Size = UDim2.new(1, 0, 0, 10)
                topBarFix.Position = UDim2.new(0, 0, 1, -10)
                topBarFix.BackgroundColor3 = Colors.background
                topBarFix.BorderSizePixel = 0
                topBarFix.Parent = topBar

                local brandLogo = Instance.new("Frame")
                brandLogo.Name = "BrandLogo"
                brandLogo.Size = UDim2.new(0, 250, 1, 0)
                brandLogo.Position = UDim2.new(0, 16, 0, 0)
                brandLogo.BackgroundTransparency = 1
                brandLogo.ZIndex = 11
                brandLogo.Parent = topBar

                local brandLogoIcon = createIconImage("minimize", 18, Colors.primary)
                brandLogoIcon.AnchorPoint = Vector2.new(0, 0.5)
                brandLogoIcon.Position = UDim2.new(0, 0, 0.5, 0)
                brandLogoIcon.ZIndex = 11
                brandLogoIcon.Parent = brandLogo

                local brandLogoText = Instance.new("TextLabel")
                brandLogoText.BackgroundTransparency = 1
                brandLogoText.Size = UDim2.new(1, -26, 1, 0)
                brandLogoText.Position = UDim2.new(0, 24, 0, 0)
                brandLogoText.Text = "Miwa Hub | Key System"
                brandLogoText.TextColor3 = Colors.textPrimary
                brandLogoText.TextSize = 14
                brandLogoText.TextXAlignment = Enum.TextXAlignment.Left
                brandLogoText.Font = Enum.Font.GothamBold
                brandLogoText.ZIndex = 11
                brandLogoText.Parent = brandLogo

                local closeButton = Instance.new("TextButton")
                closeButton.Name = "CloseButton"
                closeButton.Size = UDim2.new(0, 28, 0, 28)
                closeButton.Position = UDim2.new(1, -36, 0.5, 0)
                closeButton.AnchorPoint = Vector2.new(0, 0.5)
                closeButton.BackgroundColor3 = Colors.surfaceLight
                closeButton.BackgroundTransparency = 1
                closeButton.BorderSizePixel = 0
                closeButton.Text = ""
                closeButton.AutoButtonColor = false
                closeButton.ZIndex = 11
                closeButton.Parent = topBar

                local closeCorner = Instance.new("UICorner")
                closeCorner.CornerRadius = UDim.new(0, 6)
                closeCorner.Parent = closeButton

                local closeIcon = createIconImage("x", 14, Colors.textSecondary)
                closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                closeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
                closeIcon.ZIndex = 12
                closeIcon.Parent = closeButton

                local contentArea = Instance.new("Frame")
                contentArea.Name = "ContentArea"
                contentArea.Size = UDim2.new(1, -40, 1, -65)
                contentArea.Position = UDim2.new(0, 20, 0, 55)
                contentArea.BackgroundTransparency = 1
                contentArea.Parent = container

                local titleSection = Instance.new("Frame")
                titleSection.Name = "TitleSection"
                titleSection.Size = UDim2.new(1, 0, 0, 85)
                titleSection.Position = UDim2.new(0, 0, 0, 5)
                titleSection.BackgroundTransparency = 1
                titleSection.Parent = contentArea

                local iconFrame = Instance.new("Frame")
                iconFrame.Name = "IconFrame"
                iconFrame.Size = UDim2.new(0, 48, 0, 48)
                iconFrame.Position = UDim2.new(0.5, -24, 0, 0)
                iconFrame.BackgroundColor3 = Colors.primary
                iconFrame.BorderSizePixel = 0
                iconFrame.Parent = titleSection

                local iconCorner = Instance.new("UICorner")
                iconCorner.CornerRadius = UDim.new(1, 0)
                iconCorner.Parent = iconFrame

                local mainIcon = createIconImage("minimize", 24, Color3.fromRGB(255, 255, 255))
                mainIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                mainIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
                mainIcon.Parent = iconFrame

                local titleText = Instance.new("TextLabel")
                titleText.Name = "TitleText"
                titleText.Size = UDim2.new(1, 0, 0, 24)
                titleText.Position = UDim2.new(0, 0, 0, 56)
                titleText.BackgroundTransparency = 1
                titleText.Text = self.title
                titleText.TextColor3 = Colors.textPrimary
                titleText.TextSize = 18
                titleText.TextXAlignment = Enum.TextXAlignment.Center
                titleText.Font = Enum.Font.GothamBold
                titleText.Parent = titleSection

                local subtitleText = Instance.new("TextLabel")
                subtitleText.Name = "SubtitleText"
                subtitleText.Size = UDim2.new(1, 0, 0, 18)
                subtitleText.Position = UDim2.new(0, 0, 0, 80)
                subtitleText.BackgroundTransparency = 1
                subtitleText.Text = self.subtitle
                subtitleText.TextColor3 = Colors.textSecondary
                subtitleText.TextSize = 12
                subtitleText.TextXAlignment = Enum.TextXAlignment.Center
                subtitleText.Font = Enum.Font.Gotham
                subtitleText.Parent = titleSection

                local inputSection = Instance.new("Frame")
                inputSection.Name = "InputSection"
                inputSection.Size = UDim2.new(1, 0, 0, 42)
                inputSection.Position = UDim2.new(0, 0, 0, 115)
                inputSection.BackgroundColor3 = Colors.background
                inputSection.BorderSizePixel = 0
                inputSection.Parent = contentArea

                local inputCorner = Instance.new("UICorner")
                inputCorner.CornerRadius = UDim.new(0, 4)
                inputCorner.Parent = inputSection

                local inputStroke = Instance.new("UIStroke")
                inputStroke.Color = Colors.border
                inputStroke.Thickness = 1
                inputStroke.Transparency = 0.2
                inputStroke.Parent = inputSection

                local keyIcon = createIconImage("key", 16, Colors.textSecondary)
                keyIcon.AnchorPoint = Vector2.new(0, 0.5)
                keyIcon.Position = UDim2.new(0, 12, 0.5, 0)
                keyIcon.Parent = inputSection

                local keyInput = Instance.new("TextBox")
                keyInput.Name = "KeyInput"
                keyInput.Size = UDim2.new(1, -44, 1, 0)
                keyInput.Position = UDim2.new(0, 36, 0, 0)
                keyInput.BackgroundTransparency = 1
                keyInput.PlaceholderText = "Enter key here..."
                keyInput.PlaceholderColor3 = Colors.textMuted
                keyInput.Text = ""
                keyInput.TextColor3 = Colors.textPrimary
                keyInput.TextSize = 13
                keyInput.TextXAlignment = Enum.TextXAlignment.Left
                keyInput.TextTruncate = Enum.TextTruncate.AtEnd
                keyInput.Font = Enum.Font.GothamMedium
                keyInput.ClearTextOnFocus = false
                keyInput.Parent = inputSection

                local buttonSection = Instance.new("Frame")
                buttonSection.Name = "ButtonSection"
                buttonSection.Size = UDim2.new(1, 0, 0, 38)
                buttonSection.Position = UDim2.new(0, 0, 0, 172)
                buttonSection.BackgroundTransparency = 1
                buttonSection.Parent = contentArea

                local getLinkButton = Instance.new("TextButton")
                getLinkButton.Name = "GetLinkButton"
                getLinkButton.Size = UDim2.new(0.48, 0, 1, 0)
                getLinkButton.Position = UDim2.new(0, 0, 0, 0)
                getLinkButton.BackgroundColor3 = Colors.primary
                getLinkButton.Text = ""
                getLinkButton.Font = Enum.Font.GothamBold
                getLinkButton.TextSize = 13
                getLinkButton.BorderSizePixel = 0
                getLinkButton.AutoButtonColor = false
                getLinkButton.Parent = buttonSection

                local getLinkCorner = Instance.new("UICorner")
                getLinkCorner.CornerRadius = UDim.new(0, 4)
                getLinkCorner.Parent = getLinkButton

                local getLinkIcon = createIconImage("link", 15, Color3.fromRGB(255, 255, 255))
                getLinkIcon.AnchorPoint = Vector2.new(0, 0.5)
                getLinkIcon.Position = UDim2.new(0, 12, 0.5, 0)
                getLinkIcon.Parent = getLinkButton

                local getLinkText = Instance.new("TextLabel")
                getLinkText.Name = "ButtonText"
                getLinkText.Size = UDim2.new(1, 0, 1, 0)
                getLinkText.Position = UDim2.new(0, 0, 0, 0)
                getLinkText.BackgroundTransparency = 1
                getLinkText.Text = "Get Key Link"
                getLinkText.TextColor3 = Color3.fromRGB(255, 255, 255)
                getLinkText.Font = Enum.Font.GothamBold
                getLinkText.TextSize = 13
                getLinkText.TextXAlignment = Enum.TextXAlignment.Center
                getLinkText.Parent = getLinkButton

                local verifyButton = Instance.new("TextButton")
                verifyButton.Name = "VerifyButton"
                verifyButton.Size = UDim2.new(0.48, 0, 1, 0)
                verifyButton.Position = UDim2.new(0.52, 0, 0, 0)
                verifyButton.BackgroundColor3 = Colors.success
                verifyButton.BorderSizePixel = 0
                verifyButton.Text = ""
                verifyButton.TextSize = 13
                verifyButton.Font = Enum.Font.GothamBold
                verifyButton.AutoButtonColor = false
                verifyButton.Parent = buttonSection

                local verifyCorner = Instance.new("UICorner")
                verifyCorner.CornerRadius = UDim.new(0, 4)
                verifyCorner.Parent = verifyButton

                local verifyIcon = createIconImage("check", 15, Color3.fromRGB(255, 255, 255))
                verifyIcon.AnchorPoint = Vector2.new(0, 0.5)
                verifyIcon.Position = UDim2.new(0, 12, 0.5, 0)
                verifyIcon.Parent = verifyButton

                local verifyText = Instance.new("TextLabel")
                verifyText.Name = "ButtonText"
                verifyText.Size = UDim2.new(1, 0, 1, 0)
                verifyText.Position = UDim2.new(0, 0, 0, 0)
                verifyText.BackgroundTransparency = 1
                verifyText.Text = "Verify Key"
                verifyText.TextColor3 = Color3.fromRGB(255, 255, 255)
                verifyText.Font = Enum.Font.GothamBold
                verifyText.TextSize = 13
                verifyText.TextXAlignment = Enum.TextXAlignment.Center
                verifyText.Parent = verifyButton

                local statusBar = Instance.new("Frame")
                statusBar.Name = "StatusBar"
                statusBar.Size = UDim2.new(1, -40, 0, 2)
                statusBar.Position = UDim2.new(0.5, 0, 1, -14)
                statusBar.AnchorPoint = Vector2.new(0.5, 0)
                statusBar.BackgroundColor3 = Colors.border
                statusBar.BorderSizePixel = 0
                statusBar.Parent = container

                local statusText = Instance.new("TextLabel")
                statusText.Name = "StatusText"
                statusText.BackgroundTransparency = 1
                statusText.Text = ""
                statusText.TextColor3 = Colors.textSecondary
                statusText.Font = Enum.Font.Gotham
                statusText.TextSize = 12
                statusText.TextXAlignment = Enum.TextXAlignment.Center
                statusText.Size = UDim2.new(1, -40, 0, 20)
                statusText.Position = UDim2.new(0.5, 0, 1, -38)
                statusText.AnchorPoint = Vector2.new(0.5, 0)
                statusText.Visible = false
                statusText.Parent = container

                self.elements = {
                    backdrop = backdrop,
                    container = container,
                    iconFrame = iconFrame,
                    brandLogo = brandLogo,
                    title = titleText,
                    subtitle = subtitleText,
                    getLinkButton = getLinkButton,
                    inputContainer = inputSection,
                    inputFrame = inputSection,
                    keyInput = keyInput,
                    verifyButton = verifyButton,
                    statusBar = statusBar,
                    statusText = statusText,
                    inputStroke = inputStroke,
                    closeButton = closeButton,
                    glassOverlay = glassOverlay,
                    glowFrame = glowFrame
                }

                local function setupAnimations()
                    local elements = self.elements

                    if elements.closeButton then
                        elements.closeButton.MouseEnter:Connect(function()
                            TweenService:Create(elements.closeButton, TweenInfo.new(0.15), {
                                BackgroundTransparency = 0.5,
                                BackgroundColor3 = Colors.error
                            }):Play()
                            if closeIcon then closeIcon.ImageColor3 = Color3.fromRGB(255, 255, 255) end
                        end)

                        elements.closeButton.MouseLeave:Connect(function()
                            TweenService:Create(elements.closeButton, TweenInfo.new(0.15), {
                                BackgroundTransparency = 1,
                                BackgroundColor3 = Colors.surfaceLight
                            }):Play()
                            if closeIcon then closeIcon.ImageColor3 = Colors.textSecondary end
                        end)
                    end

                    if elements.getLinkButton then
                        elements.getLinkButton.MouseEnter:Connect(function()
                            TweenService:Create(elements.getLinkButton, TweenInfo.new(0.15), {
                                BackgroundColor3 = Colors.primaryDark
                            }):Play()
                        end)

                        elements.getLinkButton.MouseLeave:Connect(function()
                            TweenService:Create(elements.getLinkButton, TweenInfo.new(0.15), {
                                BackgroundColor3 = Colors.primary
                            }):Play()
                        end)
                    end

                    if elements.verifyButton then
                        elements.verifyButton.MouseEnter:Connect(function()
                            TweenService:Create(elements.verifyButton, TweenInfo.new(0.15), {
                                BackgroundColor3 = Colors.successDark
                            }):Play()
                        end)

                        elements.verifyButton.MouseLeave:Connect(function()
                            TweenService:Create(elements.verifyButton, TweenInfo.new(0.15), {
                                BackgroundColor3 = Colors.success
                            }):Play()
                        end)
                    end

                    if elements.keyInput and elements.inputStroke then
                        elements.keyInput.Focused:Connect(function()
                            TweenService:Create(elements.inputStroke, TweenInfo.new(0.15), {
                                Color = Colors.primary,
                                Transparency = 0
                            }):Play()
                        end)

                        elements.keyInput.FocusLost:Connect(function()
                            TweenService:Create(elements.inputStroke, TweenInfo.new(0.15), {
                                Color = Colors.border,
                                Transparency = 0.2
                            }):Play()
                        end)
                    end
                end

                local function animateEntrance()
                    local container = self.elements.container
                    local backdrop = self.elements.backdrop

                    if container then
                        container.BackgroundTransparency = 1
                        TweenService:Create(container, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            BackgroundTransparency = 0
                        }):Play()
                    end

                    if backdrop then
                        backdrop.BackgroundTransparency = 1
                        TweenService:Create(backdrop, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                            BackgroundTransparency = 0.5
                        }):Play()
                    end
                end

                self.gui.Parent = game:GetService("CoreGui")

                self.gui.AncestryChanged:Connect(function(_, parent)
                    if parent == nil then
                        local blur = Lighting:FindFirstChild("JunkieUIBlur")
                        if blur then blur:Destroy() end
                    end
                end)

                self.showSuccess = function(self, message)
                    if not self.elements then return end

                    local container = self.elements.container
                    local loadingOverlay = container:FindFirstChild("LoadingOverlay")

                    if loadingOverlay then
                        local mainContainer = loadingOverlay:FindFirstChild("MainContainer")
                        local spinnerContainer = mainContainer and mainContainer:FindFirstChild("SpinnerContainer")
                        local loadingText = mainContainer and mainContainer:FindFirstChild("LoadingText")
                        local hintText = mainContainer and mainContainer:FindFirstChild("HintText")

                        if spinnerContainer then
                            TweenService:Create(
                                spinnerContainer,
                                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {Rotation = 0}
                            ):Play()

                            task.wait(0.2)

                            local checkmarkContainer = Instance.new("Frame")
                            checkmarkContainer.Name = "CheckmarkContainer"
                            checkmarkContainer.BackgroundTransparency = 1
                            checkmarkContainer.Size = UDim2.new(1, 0, 1, 0)
                            checkmarkContainer.Position = UDim2.new(0, 0, 0, 0)
                            checkmarkContainer.Parent = mainContainer

                            local successCircle = Instance.new("Frame")
                            successCircle.Name = "SuccessCircle"
                            successCircle.BackgroundColor3 = Colors.success
                            successCircle.BackgroundTransparency = 1
                            successCircle.Size = UDim2.new(0, 70, 0, 70)
                            successCircle.Position = UDim2.new(0.5, 0, 0, 20)
                            successCircle.AnchorPoint = Vector2.new(0.5, 0)
                            successCircle.Parent = checkmarkContainer

                            local successCorner = Instance.new("UICorner")
                            successCorner.CornerRadius = UDim.new(1, 0)
                            successCorner.Parent = successCircle

                            local checkmark = Instance.new("TextLabel")
                            checkmark.Name = "Checkmark"
                            checkmark.BackgroundTransparency = 1
                            checkmark.Size = UDim2.new(1, 0, 1, 0)
                            checkmark.Font = Enum.Font.GothamBold
                            checkmark.Text = "✓"
                            checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
                            checkmark.TextSize = 36
                            checkmark.Parent = successCircle

                            TweenService:Create(
                                successCircle,
                                TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                                {BackgroundTransparency = 0}
                            ):Play()
                        end

                        if loadingText then
                            loadingText.Text = message or "Verified!"
                            loadingText.TextColor3 = Colors.success
                        end

                        if hintText then
                            hintText.Text = "Launching script..."
                            hintText.TextColor3 = Colors.textSecondary
                        end
                    end

                    task.wait(0.8)
                end

                self.updateStatus = function(self, message, color, duration)
                    local statusText = self.elements.statusText
                    local statusBar = self.elements.statusBar

                    if statusText then
                        statusText.Text = message
                        statusText.TextColor3 = color or Colors.textSecondary
                        statusText.Visible = true

                        if statusBar then
                            TweenService:Create(statusBar, TweenInfo.new(0.2), {
                                BackgroundColor3 = color or Colors.border,
                                Size = UDim2.new(1, -40, 0, 2)
                            }):Play()
                        end

                        if duration and duration > 0 then
                            task.delay(duration, function()
                                if statusText and statusText.Text == message then
                                    statusText.Visible = false
                                    if statusBar then
                                        TweenService:Create(statusBar, TweenInfo.new(0.2), {
                                            BackgroundColor3 = Colors.border,
                                            Size = UDim2.new(1, -40, 0, 2)
                                        }):Play()
                                    end
                                end
                            end)
                        end
                    end
                end

                self.setButtonLoading = function(self, button, text, loading)
                    local buttonText = button:FindFirstChild("ButtonText")
                    if buttonText then
                        buttonText.Text = text
                    end
                    button.Interactable = not loading
                end

                self.shakeInput = function(self)
                    local frame = self.elements.inputFrame
                    if not frame then return end

                    local orig = frame.Position

                    for i = 1, 3 do
                        TweenService:Create(frame, TweenInfo.new(0.04), {
                            Position = UDim2.new(orig.X.Scale, orig.X.Offset - 6, orig.Y.Scale, orig.Y.Offset)
                        }):Play()
                        task.wait(0.04)
                        TweenService:Create(frame, TweenInfo.new(0.04), {
                            Position = UDim2.new(orig.X.Scale, orig.X.Offset + 6, orig.Y.Scale, orig.Y.Offset)
                        }):Play()
                        task.wait(0.04)
                    end

                    frame.Position = orig
                end

                self.animateSuccess = function(self)
                    local iconFrame = self.elements.iconFrame
                    if iconFrame then
                        TweenService:Create(iconFrame, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
                            Size = UDim2.new(0, 54, 0, 54),
                            Position = UDim2.new(0.5, -27, 0, -3)
                        }):Play()

                        task.wait(0.15)

                        TweenService:Create(iconFrame, TweenInfo.new(0.15), {
                            Size = UDim2.new(0, 48, 0, 48),
                            Position = UDim2.new(0.5, -24, 0, 0)
                        }):Play()
                    end
                end

                self.close = function(self)
                    if not self.gui then return end
                    getgenv().UI_CLOSED = true
                    local container = self.elements.container
                    local backdrop = self.elements.backdrop
                    local blur = Lighting:FindFirstChild("JunkieUIBlur")

                    TweenService:Create(container, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1
                    }):Play()

                    TweenService:Create(backdrop, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1
                    }):Play()

                    task.wait(0.2)

                    if blur then blur:Destroy() end
                    self.gui:Destroy()
                    self.gui = nil
                end

                self.setLoadingState = function(self, isLoading, message)
                    if not self.elements then return end

                    local container = self.elements.container
                    local inputFrame = self.elements.inputFrame
                    local verifyButton = self.elements.verifyButton
                    local getLinkButton = self.elements.getLinkButton
                    local iconFrame = self.elements.iconFrame
                    local title = self.elements.title
                    local subtitle = self.elements.subtitle
                    local statusLabel = self.elements.statusLabel

                    if isLoading then
                        if inputFrame then inputFrame.Visible = false end
                        if verifyButton then verifyButton.Visible = false end
                        if getLinkButton then getLinkButton.Visible = false end
                        if iconFrame then iconFrame.Visible = false end
                        if title then title.Visible = false end
                        if subtitle then subtitle.Visible = false end
                        if statusLabel then statusLabel.Visible = false end

                        local loadingOverlay = container:FindFirstChild("LoadingOverlay")
                        if not loadingOverlay then
                            loadingOverlay = Instance.new("Frame")
                            loadingOverlay.Name = "LoadingOverlay"
                            loadingOverlay.BackgroundTransparency = 1
                            loadingOverlay.Size = UDim2.new(1, 0, 1, 0)
                            loadingOverlay.Position = UDim2.new(0, 0, 0, 0)
                            loadingOverlay.ZIndex = 100
                            loadingOverlay.Parent = container

                            local mainContainer = Instance.new("CanvasGroup")
                            mainContainer.Name = "MainContainer"
                            mainContainer.BackgroundTransparency = 1
                            mainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
                            mainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
                            mainContainer.Size = UDim2.new(0, 280, 0, 200)
                            mainContainer.Parent = loadingOverlay

                            local spinnerContainer = Instance.new("Frame")
                            spinnerContainer.Name = "SpinnerContainer"
                            spinnerContainer.BackgroundTransparency = 1
                            spinnerContainer.AnchorPoint = Vector2.new(0.5, 0)
                            spinnerContainer.Position = UDim2.new(0.5, 0, 0, 20)
                            spinnerContainer.Size = UDim2.new(0, 70, 0, 70)
                            spinnerContainer.Parent = mainContainer

                            local bgCircle = Instance.new("Frame")
                            bgCircle.Name = "BgCircle"
                            bgCircle.BackgroundTransparency = 1
                            bgCircle.Size = UDim2.new(1, 0, 1, 0)
                            bgCircle.ZIndex = 2
                            bgCircle.Parent = spinnerContainer

                            local bgStroke = Instance.new("UIStroke")
                            bgStroke.Color = Colors.primary
                            bgStroke.Thickness = 3
                            bgStroke.Transparency = 0.8
                            bgStroke.Parent = bgCircle

                            local bgCorner = Instance.new("UICorner")
                            bgCorner.CornerRadius = UDim.new(1, 0)
                            bgCorner.Parent = bgCircle

                            local arcCircle = Instance.new("Frame")
                            arcCircle.Name = "ArcCircle"
                            arcCircle.BackgroundTransparency = 1
                            arcCircle.Size = UDim2.new(1, 0, 1, 0)
                            arcCircle.ZIndex = 3
                            arcCircle.Parent = spinnerContainer

                            local arcStroke = Instance.new("UIStroke")
                            arcStroke.Color = Colors.primary
                            arcStroke.Thickness = 3
                            arcStroke.Transparency = 0
                            arcStroke.Parent = arcCircle

                            local arcCorner = Instance.new("UICorner")
                            arcCorner.CornerRadius = UDim.new(1, 0)
                            arcCorner.Parent = arcCircle

                            local arcGradient = Instance.new("UIGradient")
                            arcGradient.Transparency = NumberSequence.new({
                                NumberSequenceKeypoint.new(0, 0),
                                NumberSequenceKeypoint.new(0.5, 0.5),
                                NumberSequenceKeypoint.new(1, 1)
                            })
                            arcGradient.Rotation = 0
                            arcGradient.Parent = arcStroke

                            local spinTween = TweenService:Create(
                                spinnerContainer,
                                TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                                {Rotation = 360}
                            )
                            spinTween:Play()

                            local loadingText = Instance.new("TextLabel")
                            loadingText.Name = "LoadingText"
                            loadingText.BackgroundTransparency = 1
                            loadingText.AnchorPoint = Vector2.new(0.5, 0)
                            loadingText.Position = UDim2.new(0.5, 0, 0, 110)
                            loadingText.Size = UDim2.new(1, 0, 0, 25)
                            loadingText.Font = Enum.Font.GothamBold
                            loadingText.Text = message or "Checking verification..."
                            loadingText.TextColor3 = Colors.textPrimary
                            loadingText.TextSize = 15
                            loadingText.Parent = mainContainer

                            local hintText = Instance.new("TextLabel")
                            hintText.Name = "HintText"
                            hintText.BackgroundTransparency = 1
                            hintText.AnchorPoint = Vector2.new(0.5, 0)
                            hintText.Position = UDim2.new(0.5, 0, 0, 135)
                            hintText.Size = UDim2.new(1, 0, 0, 20)
                            hintText.Font = Enum.Font.Gotham
                            hintText.Text = "Please wait a moment"
                            hintText.TextColor3 = Colors.textSecondary
                            hintText.TextSize = 12
                            hintText.Parent = mainContainer

                            mainContainer.GroupTransparency = 1
                            TweenService:Create(
                                mainContainer,
                                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {GroupTransparency = 0}
                            ):Play()
                        end

                        loadingOverlay.Visible = true
                    else
                        if inputFrame then inputFrame.Visible = true end
                        if verifyButton then verifyButton.Visible = true end
                        if getLinkButton then getLinkButton.Visible = true end
                        if iconFrame then iconFrame.Visible = true end
                        if title then title.Visible = true end
                        if subtitle then subtitle.Visible = true end

                        local loadingOverlay = container:FindFirstChild("LoadingOverlay")
                        if loadingOverlay then
                            loadingOverlay:Destroy()
                        end
                    end
                end

                setupAnimations()
                animateEntrance()

                return self.gui
            end
        end
    end

    local UI = {}
    UI.__index = UI

    function UI.new(options)
        local self = setmetatable({}, UI)

        self.options = options or {}
        self.title = self.options.title or "Key Verification"
        self.subtitle = self.options.subtitle or "Powered by Miwa Hub"
        self.description = self.options.description or "Please enter your key to continue"

        self.player = Players.LocalPlayer
        self.gui = nil
        self.hwid = game:GetService("RbxAnalyticsService"):GetClientId()

        self._connections = {}

        return self
    end

    UI.createUI = function(self)
        local UIFactory = loadUIFactory()

        if UIFactory then
            local uiBuilder = UIFactory(Colors, Players, TweenService, UserInputService, Lighting)
            if uiBuilder then
                uiBuilder(self)
            else
                error("UI builder initialization failed")
                return
            end
        else
            error("Failed to load UI factory")
            return
        end

        if self.elements and self.elements.closeButton then
            table.insert(self._connections, self.elements.closeButton.MouseButton1Click:Connect(function()
                self:close()
            end))
        end

        if self.elements and self.elements.getLinkButton then
            table.insert(self._connections, self.elements.getLinkButton.MouseButton1Click:Connect(function()
                self:handleGetLink()
            end))
        end

        if self.elements and self.elements.verifyButton then
            table.insert(self._connections, self.elements.verifyButton.MouseButton1Click:Connect(function()
                self:handleVerifyKey()
            end))
        end

        if self.elements and self.elements.keyInput then
            table.insert(self._connections, self.elements.keyInput.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    self:handleVerifyKey()
                end
            end))
        end

        return self.gui
    end

    function UI:close()
        getgenv().UI_CLOSED = true
        for _, conn in ipairs(self._connections or {}) do
            pcall(function() conn:Disconnect() end)
        end
        self._connections = {}
        if self.gui then self.gui:Destroy() end
        return getgenv().SCRIPT_KEY
    end

    function UI:handleGetLink()
        local secureGetKeyLink = Junkie.get_key_link()
        if not secureGetKeyLink then
            self:updateStatus("System not initialized", Colors.error, 3)
            return
        end
        local link = secureGetKeyLink

        if link then
            if setclipboard then
                setclipboard(link)
                self:updateStatus("Link copied to clipboard!", Colors.success, 3)
            else
                self:updateStatus("Get link: " .. link, Colors.primary, 10)
            end
        else
            self:updateStatus("Failed to get link", Colors.error, 3)
        end
    end

    function UI:handleVerifyKey()
        local key = self.elements.keyInput.Text:gsub("%s+", "")

        if key == "" then
            self:updateStatus("Please enter a key", Colors.error, 3)
            self:shakeInput()
            return
        end

        if self.setButtonLoading then
            self:setButtonLoading(self.elements.verifyButton, "Verifying...", true)
        end
        self:updateStatus("Verifying...", Colors.primary, 0)

        if self.elements.keyInput.Interactable ~= nil then
            self.elements.keyInput.Interactable = false
        end

        local result = Junkie.check_key(key)

        if result and result.valid then
            saveVerifiedKey(key)
            self:updateStatus("Key verified!", Colors.success, 0)
            if self.animateSuccess then self:animateSuccess() end

            task.wait(1.5)
            getgenv().SCRIPT_KEY = key
            self:close()
            return
        else
            self:updateStatus("Invalid key", Colors.error, 3)
            if self.shakeInput then self:shakeInput() end

            if self.setButtonLoading then
                self:setButtonLoading(self.elements.verifyButton, "Verify Key", false)
            end
            if self.elements.keyInput.Interactable ~= nil then
                self.elements.keyInput.Interactable = true
            end
        end
    end

    local ui = UI.new(options)
    ui:createUI()

    if ui.setLoadingState then
        ui:setLoadingState(true, "Checking verification...")
    end

    local savedKey = loadVerifiedKey()
    local keyToCheck = savedKey
    if not keyToCheck then
        keyToCheck = getgenv().SCRIPT_KEY
    end

    local result = Junkie.check_key(keyToCheck)
    if result and result.valid then
        if result.message == "KEYLESS" then
            if ui.showSuccess then
                ui:showSuccess("Keyless Mode ✓")
            end
            getgenv().SCRIPT_KEY = "KEYLESS"
            if ui.close then ui:close() end
            return
        end

        if result.message == "KEY_VALID" then
            if not savedKey and keyToCheck then
                saveVerifiedKey(keyToCheck)
            end

            if ui.showSuccess then
                local successMsg = savedKey and "Saved Key Verified ✓" or "Key Verified ✓"
                ui:showSuccess(successMsg)
            end
            getgenv().SCRIPT_KEY = keyToCheck
            if ui.close then ui:close() end
            return
        end

        if savedKey and not result.key_valid then
            clearSavedKey()
        end
    end

    if ui.setLoadingState then
        ui:setLoadingState(false)
    end

    while not getgenv().UI_CLOSED do
        task.wait(0.1)
    end
    return getgenv().SCRIPT_KEY
end)()

local C = {
    bg       = Color3.fromRGB(18, 20, 27),
    card     = Color3.fromRGB(36, 39, 53),
    border   = Color3.fromRGB(54, 57, 71),
    inputBg  = Color3.fromRGB(45, 49, 60),
    text     = Color3.fromRGB(242, 243, 245),
    muted    = Color3.fromRGB(148, 155, 164),
    primary  = Color3.fromRGB(88, 101, 242),
    primaryH = Color3.fromRGB(114, 137, 218),
    success  = Color3.fromRGB(67, 181, 129),
    error_   = Color3.fromRGB(240, 71, 71),
}

local _wait      = task and task.wait or wait
local safeCopy   = (typeof(setclipboard) == "function") and setclipboard or function() end
local safeWrite  = (typeof(writefile)    == "function") and writefile    or function() end
local safeRead   = (typeof(readfile)     == "function") and readfile     or function() return nil end
local safeExists = (typeof(isfile)       == "function") and isfile       or function() return false end

-- ════════════════════════════════════════════════════════════════════
-- Services & Core Setup
-- ════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

task.wait(1)

pcall(function() GuiService:SetGameplayPausedNotificationEnabled(false) end)

local currentPlaceIdString = tostring(game.PlaceId)
local MainGameID = "97387256206808"
local RaidGameIDs = { 
    ["91071552992781"] = true, 
    ["135348858107726"] = true, 
    ["100089178860775"] = true 
}

local IsMainGame = currentPlaceIdString == MainGameID
local IsRaidGame = RaidGameIDs[currentPlaceIdString] or false
local DynamicHeaderTitle = IsMainGame and "Miwa Hub | Broken Blade | Main" or (IsRaidGame and "Miwa Hub | Broken Blade | Auto Raid" or "Miwa Hub | Broken Blade | Unknown")

task.spawn(function()
    GuiService.ErrorMessageChanged:Connect(function()
        task.wait(5)
        pcall(function()
            if #Players:GetPlayers() <= 1 then
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            else
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end
        end)
    end)
end)

local AltarFolder, ChomusukeFolder, GubbyFolder, MasterFolder
task.spawn(function()
    local npcFolder = Workspace:FindFirstChild("NPC") or (Workspace:FindFirstChild("World") and Workspace.World:FindFirstChild("NPC"))
    if not npcFolder then
        pcall(function()
            local world = Workspace:WaitForChild("World", 5)
            npcFolder = world and world:WaitForChild("NPC", 5)
        end)
    end
    if npcFolder then
        AltarFolder = npcFolder:WaitForChild("Altar", 5)
        ChomusukeFolder = npcFolder:WaitForChild("Chomusuke", 5)
        GubbyFolder = npcFolder:WaitForChild("Gubby", 5)
        MasterFolder = npcFolder:WaitForChild("Master", 5)
    end
end)

local Settings = {
    AutoFarmBoss = false, AutoFarmRaidBoss = false, AutoFarmMobs = false, AutoRaid = false, MinimizeOnDefault = false,
    AutoSkill = true, AutoAltar = false, AutoChomusuke = false, AutoOpenChest = false, AutoRerollShop = false, FastMode = false,
    SkillDelay = 0, FarmDistance = 8, BrokenExpanse = false, RaidDifficulty = "Common", MaxPlayers = 1, UIScaleValue = 1.0,
    AutoRerollBless = false, SelectedBlesses = {},
    AutoRerollRace = false, SelectedRaces = {},
    AutoRerollElement = false, SelectedElements = {},
    AutoRestart = false, AutoHighestFloor = false,
    Skills = { [Enum.KeyCode.Z] = true, [Enum.KeyCode.X] = true, [Enum.KeyCode.C] = true, [Enum.KeyCode.V] = true, [Enum.KeyCode.R] = true },
    SelectedBosses = {}, SelectedRaidBosses = {}, SelectedMobs = {},
    SelectedChests = {
        ["Common Chest"] = true, ["Uncommon Chest"] = true, ["Rare Chest"] = true,
        ["Epic Chest"] = true, ["Legendary Chest"] = true, ["Mythical Chest"] = true,
        ["Holy Chest"] = true, ["Space Chest"] = true, ["Void Chest"] = true
    }
}

local CachedFarmOffset = CFrame.new(0, 0, -Settings.FarmDistance) * CFrame.Angles(0, math.rad(180), 0)

local OrderedBosses = {"[Lv.150] NameLess Hero", "[Lv.750] Moraros", "[Lv.3000] Magador", "[Lv.4000] Ragaros", "[Lv.6000] Velik", "[Lv.8500] Nivaron", "[Lv.???] Gelaros", "[Lv.15000] Niflor", "[Lv.15000] Hraegon", "[Lv.15000] Surtrik", "[Lv.15000] Thorvak", "[Lv.15000] Space Invader"}
local OrderedRaidBosses = {"Headless Knight", "Moraros", "Magador", "Ragaros", "Velik", "Nivaron", "Gelaros", "Veyrath"}
local OrderedMobs = {"[Lv.10] Sailor", "[Lv.200] Soul Minion", "[Lv.1000] Flame Minion", "[Lv.4000] Frost Minion", "[Lv.15000] Thunder Soldier", "[Lv.15000] Frost Soldier", "[Lv.15000] Wind Soldier", "[Lv.15000] Flame Soldier"}
local OrderedBlesses = {"Fenrir", "Hel", "Jormungandr", "Odin", "Surtr", "Freyja", "Heimdall", "Loki", "Thor", "Tyr"}
local OrderedRaces = {"Aesir", "Elf", "Nether", "Vanir"}
local OrderedElements = {"Thunder", "Fire", "Wind", "Life", "Water", "Earth"}

local LowerCache = { Blesses = {}, Races = {}, Elements = {} }
for _, v in ipairs(OrderedBlesses) do LowerCache.Blesses[v] = string.lower(v) end
for _, v in ipairs(OrderedRaces) do LowerCache.Races[v] = string.lower(v) end
for _, v in ipairs(OrderedElements) do LowerCache.Elements[v] = string.lower(v) end

local RaidBossData = {
    ["Headless Knight"] = {"[Lv.3000] Black Swordsman", "[Lv.15000] Struggler", "[Nightmare] Mad Dog", "[Nightmare]Headless Knight"},
    ["Moraros"] = {"[Hard] Moraros", "[Nightmare] Moraros"},
    ["Magador"] = {"[Hard] Magador", "[Nightmare] Magador"},
    ["Ragaros"] = {"[Hard] Ragaros", "[Nightmare] Ragaros"},
    ["Velik"] = {"[Hard] Velik", "[Nightmare] Velik"},
    ["Nivaron"] = {"[Hard] Nivaron", "[Nightmare] Nivaron"},
    ["Gelaros"] = {"[Hard] Gelaros", "[Nightmare] Gelaros"},
    ["Veyrath"] = {"[Hard] Veyrath", "[Nightmare] Veyrath"}
}

local ChestMapping = {
    ["Common Chest"] = 40001, ["Uncommon Chest"] = 40002, ["Rare Chest"] = 40003,
    ["Epic Chest"] = 40004, ["Legendary Chest"] = 40005, ["Mythical Chest"] = 40006,
    ["Holy Chest"] = 40007, ["Space Chest"] = 40008, ["Void Chest"] = 40009
}
local ChestOptions = {"Common Chest", "Uncommon Chest", "Rare Chest", "Epic Chest", "Legendary Chest", "Mythical Chest", "Holy Chest", "Space Chest", "Void Chest"}
local SkillKeys = {Enum.KeyCode.R, Enum.KeyCode.V, Enum.KeyCode.C, Enum.KeyCode.X, Enum.KeyCode.Z}

local TeleportLocations = {
    { Name = "Origin Island", Pos = Vector3.new(728, 100, -195) },
    { Name = "Helheim", Pos = Vector3.new(434, 100, -82) },
    { Name = "Muspelheim", Pos = Vector3.new(-430, 100, -750) },
    { Name = "Niflheim", Pos = Vector3.new(-1452, 100, -507) },
    { Name = "Nidavellir", Pos = Vector3.new(-1348, 100, 297) },
    { Name = "Explosion", Pos = Vector3.new(-732, 100, 801) },
    { Name = "Jotunheim", Pos = Vector3.new(-2611, 100, -2204) },
    { Name = "MidGard", Pos = Vector3.new(556, 200, -2429) }
}

local ConfigFileName = "MiwaHub_BrokenBlade_Main_Config.json"

for _, v in ipairs(OrderedBosses) do Settings.SelectedBosses[v] = false end
for _, v in ipairs(OrderedRaidBosses) do Settings.SelectedRaidBosses[v] = false end
for _, v in ipairs(OrderedMobs) do Settings.SelectedMobs[v] = false end
for _, v in ipairs(OrderedBlesses) do Settings.SelectedBlesses[v] = false end
for _, v in ipairs(OrderedRaces) do Settings.SelectedRaces[v] = false end
for _, v in ipairs(OrderedElements) do Settings.SelectedElements[v] = false end

local CleanNameMap = {}
local function cacheCleanNames(list)
    for _, name in ipairs(list) do
        CleanNameMap[name] = name:gsub("%[Lv%.%d+%]%s*", ""):gsub("%[Lv%.%?%?%?%]%s*", ""):match("^%s*(.-)%s*$")
    end
end
cacheCleanNames(OrderedBosses)
cacheCleanNames(OrderedRaidBosses)
cacheCleanNames(OrderedMobs)

local Shared = ReplicatedStorage:WaitForChild("Shared", 10)
local Features = Shared and Shared:WaitForChild("Features", 10)
local CoreFolder = Shared and Shared:WaitForChild("Core", 10)

local client = Features and require(Features:WaitForChild("BackpackSync"):WaitForChild("client"))
local TEvent = CoreFolder and require(CoreFolder:WaitForChild("TEvent"))
local Core = CoreFolder and require(CoreFolder:WaitForChild("Value"))
local Config = ReplicatedStorage:FindFirstChild("Config") and require(ReplicatedStorage.Config)
local MatchZone = Features and Features:FindFirstChild("MatchZone") and require(Features.MatchZone)

-- Endless Tower Definitions & Modules
local TowerDefs = {
    VALUE_KEY = "New_TowerChallengeState",
    PEAK_LAYER_KEY = "New_TowerPeakLayer",
    ALL_TIME_PEAK_LAYER_KEY = "New_TowerAllTimePeakLayer",
    START_REQUEST_EVENT = "New_TowerChallenge_StartRequest",
    STATUS = { Idle = "Idle", Started = "Started", FloorRunning = "FloorRunning", Failed = "Failed" }
}

local NewTowerChallengeModule = Features and Features:FindFirstChild("New_TowerChallenge") and require(Features.New_TowerChallenge)
if NewTowerChallengeModule then
    for k, v in pairs(NewTowerChallengeModule) do
        TowerDefs[k] = v
    end
end

local function getCoreValue(key)
    if not key or not Core then return nil end
    local val = Core[key]
    if type(val) == "function" then
        local ok, result = pcall(val)
        if ok then return result end
    elseif type(val) == "table" and val.Value ~= nil then
        return val.Value
    elseif val ~= nil then
        return val
    end
    return nil
end

local DescendantAddedConnection

local function applyFastMode(state)
    Lighting.GlobalShadows = not state
    local material = state and Enum.Material.SmoothPlastic or Enum.Material.Plastic
    
    task.spawn(function()
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") then 
                obj.Material = material 
                count += 1
                if count % 100 == 0 then task.wait() end
            end
        end
    end)
end

local function toggleFastModeListener(state)
    if DescendantAddedConnection then DescendantAddedConnection:Disconnect() DescendantAddedConnection = nil end
    if state then
        local world = Workspace:FindFirstChild("World") or Workspace
        local targets = world:FindFirstChild("Map") or world
        
        DescendantAddedConnection = targets.DescendantAdded:Connect(function(desc)
            if desc:IsA("BasePart") then 
                task.defer(function() 
                    if desc.Parent then desc.Material = Enum.Material.SmoothPlastic end 
                end) 
            end
        end)
    end
end

local function saveConfig()
    if typeof(writefile) ~= "function" then return end
    local data = {
        AutoFarmBoss = Settings.AutoFarmBoss, AutoFarmRaidBoss = Settings.AutoFarmRaidBoss, AutoFarmMobs = Settings.AutoFarmMobs,
        AutoRaid = Settings.AutoRaid, AutoSkill = Settings.AutoSkill, AutoAltar = Settings.AutoAltar, AutoChomusuke = Settings.AutoChomusuke,
        MinimizeOnDefault = Settings.MinimizeOnDefault, AutoOpenChest = Settings.AutoOpenChest, AutoRerollShop = Settings.AutoRerollShop,
        FastMode = Settings.FastMode, SkillDelay = Settings.SkillDelay, FarmDistance = Settings.FarmDistance, BrokenExpanse = Settings.BrokenExpanse,
        RaidDifficulty = Settings.RaidDifficulty, MaxPlayers = Settings.MaxPlayers, UIScaleValue = Settings.UIScaleValue,
        SelectedBosses = Settings.SelectedBosses, SelectedRaidBosses = Settings.SelectedRaidBosses, SelectedMobs = Settings.SelectedMobs,
        SelectedChests = Settings.SelectedChests, AutoRerollBless = Settings.AutoRerollBless, SelectedBlesses = Settings.SelectedBlesses,
        AutoRerollRace = Settings.AutoRerollRace, SelectedRaces = Settings.SelectedRaces,
        AutoRerollElement = Settings.AutoRerollElement, SelectedElements = Settings.SelectedElements,
        AutoRestart = Settings.AutoRestart, AutoHighestFloor = Settings.AutoHighestFloor, Skills = {}
    }
    for key, enabled in pairs(Settings.Skills) do data.Skills[key.Name] = enabled end
    pcall(function() writefile(ConfigFileName, HttpService:JSONEncode(data)) end)
end

local function loadConfig()
    if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" or not isfile(ConfigFileName) then return end
    pcall(function()
        local data = HttpService:JSONDecode(readfile(ConfigFileName))
        if data then
            for k, v in pairs(data) do
                if k == "Skills" then
                    for name, enabled in pairs(v) do
                        local key = Enum.KeyCode[name]
                        if key then Settings.Skills[key] = enabled end
                    end
                elseif Settings[k] ~= nil then
                    Settings[k] = v
                end
            end
        end
    end)
    CachedFarmOffset = CFrame.new(0, 0, -Settings.FarmDistance) * CFrame.Angles(0, math.rad(180), 0)
end

local function resetConfigToDefault()
    if typeof(isfile) == "function" and isfile(ConfigFileName) then
        if typeof(delfile) == "function" then pcall(function() delfile(ConfigFileName) end) end
    end
    Settings.AutoFarmBoss = false
    Settings.AutoFarmRaidBoss = false
    Settings.AutoFarmMobs = false
    Settings.AutoRaid = false
    Settings.MinimizeOnDefault = false
    Settings.AutoSkill = true
    Settings.AutoAltar = false
    Settings.AutoChomusuke = false
    Settings.AutoOpenChest = false
    Settings.AutoRerollShop = false
    Settings.FastMode = false
    Settings.SkillDelay = 0
    Settings.FarmDistance = 6
    CachedFarmOffset = CFrame.new(0, 0, -Settings.FarmDistance) * CFrame.Angles(0, math.rad(180), 0)
    Settings.BrokenExpanse = false
    Settings.RaidDifficulty = "Common"
    Settings.MaxPlayers = 1
    Settings.UIScaleValue = 1.0
    Settings.AutoRerollBless = false
    Settings.AutoRerollRace = false
    Settings.AutoRerollElement = false
    Settings.AutoRestart = false
    Settings.AutoHighestFloor = false
    
    Settings.Skills = { [Enum.KeyCode.Z] = true, [Enum.KeyCode.X] = true, [Enum.KeyCode.C] = true, [Enum.KeyCode.V] = true, [Enum.KeyCode.R] = true }
    for _, v in ipairs(OrderedBosses) do Settings.SelectedBosses[v] = false end
    for _, v in ipairs(OrderedRaidBosses) do Settings.SelectedRaidBosses[v] = false end
    for _, v in ipairs(OrderedMobs) do Settings.SelectedMobs[v] = false end
    for _, v in ipairs(OrderedBlesses) do Settings.SelectedBlesses[v] = false end
    for _, v in ipairs(OrderedRaces) do Settings.SelectedRaces[v] = false end
    for _, v in ipairs(OrderedElements) do Settings.SelectedElements[v] = false end
    Settings.SelectedChests = {
        ["Common Chest"] = true, ["Uncommon Chest"] = true, ["Rare Chest"] = true,
        ["Epic Chest"] = true, ["Legendary Chest"] = true, ["Mythical Chest"] = true,
        ["Holy Chest"] = true, ["Space Chest"] = true, ["Void Chest"] = true
    }
    saveConfig()
end

loadConfig()
task.spawn(function() if Settings.FastMode then applyFastMode(true) toggleFastModeListener(true) end end)

local function getCharacter()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and hrp then return char, hrp end
    end
    return nil, nil
end

local function equipWeapon(char)
    if char and not char:FindFirstChildOfClass("Tool") then
        local tool = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if tool then tool.Parent = char end
    end
end

local function firePrompt(prompt)
    if fireproximityprompt then fireproximityprompt(prompt) else prompt:DoTrigger() end
end

local IsInteractingMaster = false
local function InteractWithMaster(id)
    if IsInteractingMaster or not MasterFolder then return end
    local master = MasterFolder:FindFirstChild(id)
    if not master then return end
    local talk = master:FindFirstChild("Talk")
    if not talk or not talk:IsA("BasePart") then return end
    local prompt = talk:FindFirstChildOfClass("ProximityPrompt")
    if not prompt then return end

    IsInteractingMaster = true
    task.spawn(function()
        pcall(function()
            local char = getCharacter()
            if char then
                char:PivotTo(talk.CFrame * CFrame.new(0, 1.5, 0))
                task.wait(0.2)
                firePrompt(prompt)
            end
        end)
        IsInteractingMaster = false
    end)
end

local function NPC_Teleport(category, id)
    pcall(function()
        local npcFolder = Workspace:FindFirstChild("NPC") or (Workspace:FindFirstChild("World") and Workspace.World:FindFirstChild("NPC"))
        if not npcFolder then return end
        local folder = npcFolder:FindFirstChild(category)
        local model = folder and folder:FindFirstChild(id)
        if model and LocalPlayer.Character then LocalPlayer.Character:PivotTo(model:GetPivot()) end
    end)
end

local TargetCache = {}
local function startTrackingContainer(folder)
    if not folder then return end
    for _, child in ipairs(folder:GetChildren()) do TargetCache[child] = true end
    folder.ChildAdded:Connect(function(child) TargetCache[child] = true end)
    folder.ChildRemoved:Connect(function(child) TargetCache[child] = nil end)
end

task.spawn(function()
    startTrackingContainer(Workspace:WaitForChild("EnemyService", 10))
    Workspace.ChildAdded:Connect(function(child)
        if child.Name:find("DragonAltars_EnemyService") then startTrackingContainer(child) end
    end)
    local npcFolder = Workspace:FindFirstChild("NPC") or (Workspace:FindFirstChild("World") and Workspace.World:FindFirstChild("NPC"))
    if npcFolder then startTrackingContainer(npcFolder) end
end)

local function checkTargetEntity(name)
    if not name then return nil end
    local cleanName = CleanNameMap[name] or name
    for child in pairs(TargetCache) do
        if child.Parent then
            local childName = child.Name
            if childName == name or childName == cleanName or childName:find(cleanName, 1, true) then
                local hum = child:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health > 0.1 then return child end
            end
        else
            TargetCache[child] = nil
        end
    end
    return nil
end

local CurrentLockedTarget = nil
local CurrentBossLock = nil
local CurrentRaidLock = nil
local CurrentMobLock = nil

local function getActiveTarget()
    if Settings.AutoFarmBoss then
        if CurrentBossLock and Settings.SelectedBosses[CurrentBossLock] then
            local target = checkTargetEntity(CurrentBossLock)
            if target then CurrentLockedTarget = target return target end
        end
        for _, name in ipairs(OrderedBosses) do
            if Settings.SelectedBosses[name] then
                local target = checkTargetEntity(name)
                if target then CurrentBossLock = name CurrentLockedTarget = target return target end
            end
        end
        CurrentBossLock = nil
    end

    if Settings.AutoFarmRaidBoss then
        if CurrentRaidLock and Settings.SelectedRaidBosses[CurrentRaidLock] then
            local variants = RaidBossData[CurrentRaidLock]
            if variants then
                for _, v in ipairs(variants) do
                    local target = checkTargetEntity(v)
                    if target then CurrentLockedTarget = target return target end
                end
            end
        end
        for _, raidName in ipairs(OrderedRaidBosses) do
            if Settings.SelectedRaidBosses[raidName] then
                local variants = RaidBossData[raidName]
                if variants then
                    for _, v in ipairs(variants) do
                        local target = checkTargetEntity(v)
                        if target then CurrentLockedTarget = target return target end
                    end
                end
            end
        end
        CurrentRaidLock = nil
    end

    if Settings.AutoFarmMobs then
        if CurrentMobLock and Settings.SelectedMobs[CurrentMobLock] then
            local target = checkTargetEntity(CurrentMobLock)
            if target then CurrentLockedTarget = target return target end
        end
        for _, name in ipairs(OrderedMobs) do
            if Settings.SelectedMobs[name] then
                local target = checkTargetEntity(name)
                if target then CurrentMobLock = name CurrentLockedTarget = target return target end
            end
        end
        CurrentMobLock = nil
    end
    CurrentLockedTarget = nil
    return nil
end

local function RawTeleport(pos)
    local char, hrp = getCharacter()
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        char:PivotTo(CFrame.new(pos))
        task.wait(0.05)
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
end

local function applyDragging(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true startPos = frame.Position dragStart = input.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function getRaidIdByDifficulty(diffName)
    if not Config then return nil end
    local raidConfig = Config.Dungeon and Config.Dungeon.Raid
    if not raidConfig then return nil end
    local realDefinitions = raidConfig._def or raidConfig
    for id, data in pairs(realDefinitions) do
        if type(data) == "table" and tostring(data.difficulty or "") == diffName then return tonumber(id) or data.id end
    end
    return nil
end

local function getActiveZoneId()
    if not Core or not MatchZone then return nil end
    local runtimeState = Core[MatchZone.VALUE_KEY]() or {}
    for zoneId, state in pairs(runtimeState) do
        if state.status == MatchZone.STATUS.Customizing and state.hostId == LocalPlayer.UserId then return zoneId end
    end
    return nil
end

local function getAnyFallbackZoneId()
    if not Core or not MatchZone then return nil end
    local runtimeState = Core[MatchZone.VALUE_KEY]() or {}
    for zoneId, _ in pairs(runtimeState) do if zoneId then return zoneId end end
    return nil
end

-- Endless Tower Request Helpers
local function getHighestFloor()
    local towerState = getCoreValue(TowerDefs.VALUE_KEY)
    local peak = nil

    if type(towerState) == "table" then
        peak = towerState.peakLayer or towerState.PeakLayer
            or towerState.highestLayer or towerState.HighestLayer
            or towerState.layer or towerState.Layer
            or towerState.floor or towerState.Floor
    end

    peak = peak or getCoreValue(TowerDefs.PEAK_LAYER_KEY)
        or getCoreValue(TowerDefs.ALL_TIME_PEAK_LAYER_KEY)
        or LocalPlayer:GetAttribute("TowerPeakLayer")
        or LocalPlayer:GetAttribute("PeakLayer")

    if type(peak) == "number" and peak > 0 then
        return peak
    elseif type(peak) == "string" and tonumber(peak) then
        return tonumber(peak)
    end
    return 1
end

local function requestTowerStart()
    local targetFloor = 1
    if Settings.AutoHighestFloor then
        targetFloor = getHighestFloor()
    end

    local floorNum = tonumber(targetFloor) or 1
    pcall(function()
        TEvent.FireRemote(TowerDefs.START_REQUEST_EVENT, {
            action = TowerDefs.ACTION and TowerDefs.ACTION.Start or "Start",
            layer = floorNum,
            floor = floorNum,
            startLayer = floorNum
        })
    end)
end

-- ════════════════════════════════════════════════════════════════════
-- Background Tasks & Loops
-- ════════════════════════════════════════════════════════════════════

local BackgroundTaskClock, ChomusukeClock, BlessRerollClock, RaceRerollClock, ElementRerollClock, TowerClock = 0, 0, 0, 0, 0, 0
local ScriptRunning = true
local HeartbeatConnection, SteppedConnection

HeartbeatConnection = RunService.Heartbeat:Connect(function(dt)
    if not ScriptRunning then return end
    BackgroundTaskClock += dt
    
    local shouldRunReroll = (math.floor(BackgroundTaskClock * 10) % 50 == 0)   
    local shouldRunChests = (math.floor(BackgroundTaskClock * 10) % 100 == 0)  

    if shouldRunChests and Settings.AutoOpenChest then
        for name, enabled in pairs(Settings.SelectedChests) do
            local id = ChestMapping[name]
            if id and enabled and client then pcall(client.OpenChest, id, 1000, false) end
        end
    end

    if shouldRunReroll and Settings.AutoRerollShop then
        pcall(function()
            local RerollShop = require(ReplicatedStorage.Shared.Features.RerollShop)
            for i = 1, 6 do
                TEvent.FireRemote(RerollShop.OP_EVENT, {op = RerollShop.OP.Buy, slotIndex = i})
                task.wait(0.22)  
            end
        end)
    end

    if BackgroundTaskClock >= 1.0 then
        BackgroundTaskClock = 0
        if Settings.BrokenExpanse and IsMainGame then
            pcall(function()
                local matchObj = Workspace:FindFirstChild("Match", true)
                if matchObj then
                    local char = getCharacter()
                    if char then char:PivotTo(matchObj:GetPivot() * CFrame.new(0, 8, 0)) end
                end
                local targetRaidId = getRaidIdByDifficulty(Settings.RaidDifficulty)
                local targetZoneId = getActiveZoneId() or getAnyFallbackZoneId()
                if targetRaidId and MatchZone then
                    if targetZoneId then
                        TEvent.FireRemote(MatchZone.OP_EVENT, {zoneId = targetZoneId, op = MatchZone.OP.ConfirmCustomization, customization = {raidId = targetRaidId, maxPlayers = Settings.MaxPlayers or 1}})
                    else
                        TEvent.FireRemote(MatchZone.OP_EVENT, {zoneId = 1, op = "JoinMatch"})
                    end
                end
            end)
        end
    end

    TowerClock += dt
    if TowerClock >= 0.8 then
        TowerClock = 0
        if IsRaidGame and Settings.AutoRestart then
            pcall(function()
                local towerState = getCoreValue(TowerDefs.VALUE_KEY)
                local currentStatus = nil
                
                if type(towerState) == "table" then
                    currentStatus = towerState.status or towerState.Status or towerState.state
                elseif type(towerState) == "string" then
                    currentStatus = towerState
                end

                local isIdleOrFailed = (currentStatus == TowerDefs.STATUS.Idle) 
                    or (currentStatus == TowerDefs.STATUS.Failed) 
                    or (currentStatus == "Failed") 
                    or (currentStatus == "Idle") 
                    or (currentStatus == nil)

                if isIdleOrFailed then
                    requestTowerStart()
                end
            end)
        end
    end

    ChomusukeClock += dt
    if ChomusukeClock >= 0.5 then
        ChomusukeClock = 0
        if IsMainGame and Settings.AutoChomusuke then
            local targets = {}
            if ChomusukeFolder then for _, npc in ipairs(ChomusukeFolder:GetChildren()) do table.insert(targets, npc) end end
            if GubbyFolder then for _, npc in ipairs(GubbyFolder:GetChildren()) do table.insert(targets, npc) end end
            
            task.spawn(function()
                pcall(function()
                    local char = getCharacter()
                    if not char then return end
                    for _, npc in ipairs(targets) do
                        if not Settings.AutoChomusuke then break end
                        local targetPart = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart or npc:FindFirstChildWhichIsA("BasePart")
                        if targetPart then
                            local prompt = targetPart:FindFirstChildWhichIsA("ProximityPrompt", true) or npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and prompt.Enabled then
                                char:PivotTo(targetPart.CFrame * CFrame.new(0, 2, 0))
                                task.wait(0.05)
                                if prompt.Enabled then firePrompt(prompt) end
                            end
                        end
                    end
                end)
            end)
        end
    end

    BlessRerollClock += dt
    if BlessRerollClock >= 0.6 then
        BlessRerollClock = 0
        if IsMainGame and Settings.AutoRerollBless then
            pcall(function()
                local label = LocalPlayer.PlayerGui.Main.Func.Stats.Content.Profile.Outline.RightContent.Inner.Bless.Title
                if label and label.Text ~= "" then
                    local uiTextLower = string.lower(label.Text)
                    local foundMatch = false
                    for blessName, enabled in pairs(Settings.SelectedBlesses) do
                        if enabled and string.find(uiTextLower, LowerCache.Blesses[blessName]) then
                            foundMatch = true
                            break
                        end
                    end
                    if foundMatch then
                        Settings.AutoRerollBless = false
                    else
                        TEvent.FireRemote("BackpackOp", {op = "UseTicket", count = 1, ticketId = 51003})
                    end
                end
            end)
        end
    end

    RaceRerollClock += dt
    if RaceRerollClock >= 0.6 then
        RaceRerollClock = 0
        if IsMainGame and Settings.AutoRerollRace then
            pcall(function()
                local label = LocalPlayer.PlayerGui.Main.Func.Stats.Content.Profile.Outline.RightContent.Inner.Race.Title
                if label and label.Text ~= "" then
                    local uiTextLower = string.lower(label.Text)
                    local foundMatch = false
                    for raceName, enabled in pairs(Settings.SelectedRaces) do
                        if enabled and string.find(uiTextLower, LowerCache.Races[raceName]) then
                            foundMatch = true
                            break
                        end
                    end
                    if foundMatch then
                        Settings.AutoRerollRace = false
                    else
                        TEvent.FireRemote("BackpackOp", {op = "UseTicket", count = 1, ticketId = 51002})
                    end
                end
            end)
        end
    end

    ElementRerollClock += dt
    if ElementRerollClock >= 0.6 then
        ElementRerollClock = 0
        if IsMainGame and Settings.AutoRerollElement then
            pcall(function()
                local label = LocalPlayer.PlayerGui.Main.Func.Stats.Content.Profile.Outline.RightContent.Inner.Element.Title
                if label and label.Text ~= "" then
                    local uiTextLower = string.lower(label.Text)
                    local foundMatch = false
                    for elementName, enabled in pairs(Settings.SelectedElements) do
                        if enabled and string.find(uiTextLower, LowerCache.Elements[elementName]) then
                            foundMatch = true
                            break
                        end
                    end
                    if foundMatch then
                        Settings.AutoRerollElement = false
                    else
                        TEvent.FireRemote("BackpackOp", {op = "UseTicket", count = 1, ticketId = 51001})
                    end
                end
            end)
        end
    end
end)

-- ════════════════════════════════════════════════════════════════════
-- UI Framework Construction
-- ════════════════════════════════════════════════════════════════════

local MiwaHub = {}
MiwaHub.__index = MiwaHub
local TabClass = {}
TabClass.__index = TabClass

local StatusLabel

function MiwaHub.CreateWindow(hubTitle)
    local self = setmetatable({}, MiwaHub)
    self.ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.MasterScaleConstraint = Instance.new("UIScale", self.ScreenGui)
    self.MasterScaleConstraint.Scale = Settings.UIScaleValue

    self.MainFrame = Instance.new("Frame", self.ScreenGui)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.BackgroundColor3 = C.bg
    self.MainFrame.Size = UDim2.new(0.44902, 0, 0.5, 0)
    self.MainFrame.Position = UDim2.new(0.27497, 0, 0.25, 0)
    self.MainFrame.Name = "Main Frame"
    self.MainFrame.Visible = not Settings.MinimizeOnDefault

    Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 8)
    local MainFrameStroke = Instance.new("UIStroke", self.MainFrame)
    MainFrameStroke.Thickness = 1.5
    MainFrameStroke.Color = C.border

    local Header = Instance.new("Frame", self.MainFrame)
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(0.99771, 0, 0.09615, 0)
    Header.BackgroundColor3 = C.card
    Header.BackgroundTransparency = 0

    local TitleTemplate = Instance.new("TextLabel", Header)
    TitleTemplate.TextSize = 16
    TitleTemplate.TextXAlignment = Enum.TextXAlignment.Left 
    TitleTemplate.Font = Enum.Font.GothamBold
    TitleTemplate.TextColor3 = C.text
    TitleTemplate.BackgroundTransparency = 1
    TitleTemplate.Size = UDim2.new(0.85977, 0, 1, 0)
    TitleTemplate.Text = "  " .. hubTitle
    TitleTemplate.Position = UDim2.new(0, 0, 0.2, 0)

    local Minimize = Instance.new("TextButton", Header)
    Minimize.TextSize = 14
    Minimize.TextScaled = true
    Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.BackgroundColor3 = C.primary
    Minimize.Font = Enum.Font.Gotham
    Minimize.Size = UDim2.new(0.05747, 0, 1, 0)
    Minimize.Text = "-"
    Minimize.Position = UDim2.new(0.85747, 0, 0.2, 0)
    Minimize.AutoButtonColor = false
    Instance.new("UICorner", Minimize).CornerRadius = UDim.new(0, 4)

    local Kill = Instance.new("TextButton", Header)
    Kill.TextSize = 14
    Kill.TextColor3 = Color3.fromRGB(255, 255, 255)
    Kill.BackgroundColor3 = C.error_
    Kill.Font = Enum.Font.Gotham
    Kill.Size = UDim2.new(0.05747, 0, 1, 0)
    Kill.Text = "X"
    Kill.Position = UDim2.new(0.92874, 0, 0.2, 0)
    Kill.AutoButtonColor = false
    Instance.new("UICorner", Kill).CornerRadius = UDim.new(0, 4)

    self.CategorySidebar = Instance.new("Frame", self.MainFrame)
    self.CategorySidebar.BorderSizePixel = 0
    self.CategorySidebar.BackgroundColor3 = C.bg
    self.CategorySidebar.Size = UDim2.new(0.22936, 0, 0.84231, 0)
    self.CategorySidebar.Position = UDim2.new(0.01147, 0, 0.13462, 0)
    Instance.new("UICorner", self.CategorySidebar).CornerRadius = UDim.new(0, 6)

    local SidebarPadding = Instance.new("UIPadding", self.CategorySidebar)
    SidebarPadding.PaddingTop = UDim.new(0, 4)

    local SidebarListLayout = Instance.new("UIListLayout", self.CategorySidebar)
    SidebarListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarListLayout.Padding = UDim.new(0, 4)
    SidebarListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local SidebarStroke = Instance.new("UIStroke", self.CategorySidebar)
    SidebarStroke.Thickness = 1
    SidebarStroke.Color = C.border

    self.CategoryContents = Instance.new("Frame", self.MainFrame)
    self.CategoryContents.BorderSizePixel = 0
    self.CategoryContents.BackgroundColor3 = C.bg
    self.CategoryContents.Size = UDim2.new(0.73394, 0, 0.84231, 0)
    self.CategoryContents.Position = UDim2.new(0.25, 0, 0.13462, 0)
    Instance.new("UICorner", self.CategoryContents).CornerRadius = UDim.new(0, 6)

    local ContentStroke = Instance.new("UIStroke", self.CategoryContents)
    ContentStroke.Thickness = 1
    ContentStroke.Color = C.border

    local MinimizeIcon = Instance.new("ImageButton", self.ScreenGui)
    MinimizeIcon.BorderSizePixel = 0
    MinimizeIcon.Visible = Settings.MinimizeOnDefault
    MinimizeIcon.BackgroundColor3 = C.card
    MinimizeIcon.Image = "rbxassetid://124692664228518"
    MinimizeIcon.Size = UDim2.new(0, 50, 0, 50)
    MinimizeIcon.Position = UDim2.new(0.25, 25, 0.19038, -50)
    Instance.new("UICorner", MinimizeIcon).CornerRadius = UDim.new(0, 8)
    local MinimizeIconStroke = Instance.new("UIStroke", MinimizeIcon)
    MinimizeIconStroke.Thickness = 1.5
    MinimizeIconStroke.Color = C.primary

    applyDragging(self.MainFrame, Header)
    applyDragging(MinimizeIcon)

    Kill.MouseButton1Click:Connect(function() if _G.BahadeHubShutdown then _G.BahadeHubShutdown() end end)
    Minimize.MouseButton1Click:Connect(function() self.MainFrame.Visible = not self.MainFrame.Visible MinimizeIcon.Visible = not self.MainFrame.Visible end)
    MinimizeIcon.MouseButton1Click:Connect(function() self.MainFrame.Visible = not self.MainFrame.Visible MinimizeIcon.Visible = not self.MainFrame.Visible end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
            self.MainFrame.Visible = not self.MainFrame.Visible
            MinimizeIcon.Visible = not self.MainFrame.Visible
        end
    end)

    self.Tabs = {}
    self.FirstTab = nil
    return self
end

function MiwaHub:AddTab(tabName)
    local tabNumber = #self.Tabs + 1
    local tabSelf = setmetatable({}, TabClass)
    
    local SidebarButton = Instance.new("TextButton", self.CategorySidebar)
    SidebarButton.BorderSizePixel = 0
    SidebarButton.TextSize = 13
    SidebarButton.TextColor3 = C.muted
    SidebarButton.BackgroundColor3 = C.card
    SidebarButton.Font = Enum.Font.Gotham
    SidebarButton.Size = UDim2.new(0.9, 0, 0.11, 0)
    SidebarButton.LayoutOrder = tabNumber
    SidebarButton.Text = tabName
    SidebarButton.AutoButtonColor = false
    Instance.new("UICorner", SidebarButton).CornerRadius = UDim.new(0, 6)

    tabSelf.Button = SidebarButton
    tabSelf.ContentFrame = Instance.new("ScrollingFrame", self.CategoryContents)
    tabSelf.ContentFrame.Visible = false
    tabSelf.ContentFrame.BackgroundTransparency = 1
    tabSelf.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    tabSelf.ContentFrame.ScrollBarThickness = 4
    tabSelf.ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabSelf.ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ListLayout = Instance.new("UIListLayout", tabSelf.ContentFrame)
    ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ListLayout.Padding = UDim.new(0, 4)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local Padding = Instance.new("UIPadding", tabSelf.ContentFrame)
    Padding.PaddingTop = UDim.new(0, 4)

    SidebarButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do 
            tab.ContentFrame.Visible = false 
            tab.Button.BackgroundColor3 = C.inputBg
            tab.Button.TextColor3 = C.muted
        end
        tabSelf.ContentFrame.Visible = true
        SidebarButton.BackgroundColor3 = C.primary
        SidebarButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    if not self.FirstTab then 
        self.FirstTab = tabSelf.ContentFrame 
        tabSelf.ContentFrame.Visible = true 
        SidebarButton.BackgroundColor3 = C.primary
        SidebarButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    table.insert(self.Tabs, tabSelf)
    return tabSelf
end

function TabClass:AddLabel(text)
    local TextLabel = Instance.new("TextLabel", self.ContentFrame)
    TextLabel.BorderSizePixel = 0
    TextLabel.TextSize = 13
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextColor3 = C.muted
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(0.96875, 0, 0, 18)
    
    if text:match("^%s*%-%-") then
        TextLabel.TextXAlignment = Enum.TextXAlignment.Center
        TextLabel.Text = text
    else
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.Text = "  " .. text
    end
    
    return TextLabel
end

function TabClass:AddButton(text, callback)
    local Button = Instance.new("TextButton", self.ContentFrame)
    Button.BorderSizePixel = 0
    Button.TextSize = 13
    Button.TextColor3 = C.text
    Button.BackgroundColor3 = C.inputBg
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.Font = Enum.Font.Gotham
    Button.Size = UDim2.new(0.96875, 0, 0, 28)
    Button.Text = "  " .. text
    Button.AutoButtonColor = false
    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)
    Button.MouseButton1Click:Connect(function() if callback then callback() end end)
    return Button
end

function TabClass:AddToggle(text, default, callback)
    local ToggleFrame = Instance.new("Frame", self.ContentFrame)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.BackgroundColor3 = C.inputBg
    ToggleFrame.Size = UDim2.new(0.96875, 0, 0, 28)
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

    local ToggleLabel = Instance.new("TextLabel", ToggleFrame)
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.TextColor3 = C.text
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    ToggleLabel.Text = "  " .. text
    ToggleLabel.Font = Enum.Font.Gotham

    local ToggleTrack = Instance.new("Frame", ToggleFrame)
    ToggleTrack.BackgroundColor3 = C.border
    ToggleTrack.Size = UDim2.new(0.13, 0, 0.5, 0)
    ToggleTrack.Position = UDim2.new(0.88, 0, 0.25, 0)
    ToggleTrack.BorderSizePixel = 0
    Instance.new("UICorner", ToggleTrack).CornerRadius = UDim.new(0, 12)

    local ToggleKnob = Instance.new("Frame", ToggleTrack)
    ToggleKnob.BackgroundColor3 = C.card
    ToggleKnob.Size = UDim2.new(0.45, 0, 0.8, 0)
    ToggleKnob.Position = UDim2.new(0.05, 0, 0.1, 0)
    ToggleKnob.BorderSizePixel = 0
    Instance.new("UICorner", ToggleKnob).CornerRadius = UDim.new(0, 12)

    local ToggleButton = Instance.new("TextButton", ToggleFrame)
    ToggleButton.BackgroundTransparency = 1
    ToggleButton.Size = UDim2.new(0.13, 0, 0.5, 0)
    ToggleButton.Position = UDim2.new(0.88, 0, 0.25, 0)
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false

    local state = default or false
    local function update()
        ToggleTrack.BackgroundColor3 = state and C.success or C.border
        ToggleKnob.Position = state and UDim2.new(0.55, 0, 0.1, 0) or UDim2.new(0.05, 0, 0.1, 0)
        if callback then callback(state) end
    end
    update()

    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        update()
    end)
    return ToggleFrame
end

function TabClass:AddDropdown(text, currentTable, optionsList, isMulti, callback)
    local DropdownFrame = Instance.new("Frame", self.ContentFrame)
    DropdownFrame.BackgroundColor3 = C.inputBg
    DropdownFrame.Size = UDim2.new(0.96875, 0, 0, 28)
    DropdownFrame.ClipsDescendants = true
    Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 8)

    local mainBtn = Instance.new("TextButton", DropdownFrame)
    mainBtn.Size = UDim2.new(1, 0, 0, 28)
    mainBtn.BackgroundTransparency = 1
    mainBtn.TextColor3 = C.text
    mainBtn.Font = Enum.Font.Gotham
    mainBtn.TextSize = 13
    mainBtn.TextXAlignment = Enum.TextXAlignment.Left
    mainBtn.AutoButtonColor = false

    local OptionsList = Instance.new("ScrollingFrame", DropdownFrame)
    OptionsList.Visible = false
    OptionsList.BackgroundColor3 = C.border
    OptionsList.Size = UDim2.new(1, 0, 0, 120)
    OptionsList.Position = UDim2.new(0, 0, 0, 28)
    OptionsList.ScrollBarThickness = 4
    OptionsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    OptionsList.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = Instance.new("UIListLayout", OptionsList)
    layout.Padding = UDim.new(0, 2)

    local function updateText()
        if isMulti then
            local active = {}
            for _, o in ipairs(optionsList) do if currentTable[o] then table.insert(active, o) end end
            if #active == 0 then mainBtn.Text = "  " .. text .. " : None"
            elseif #active == 1 then mainBtn.Text = "  " .. text .. " : " .. active[1]
            else mainBtn.Text = "  " .. text .. " : Various" end
        else
            mainBtn.Text = "  " .. text .. " : [" .. tostring(Settings[currentTable]) .. "]"
        end
    end

    mainBtn.MouseButton1Click:Connect(function()
        OptionsList.Visible = not OptionsList.Visible
        local baseHeight = 28
        local itemHeight = #optionsList * 24
        local controlHeight = isMulti and 26 or 0
        local totalExpandedHeight = math.min(baseHeight + itemHeight + controlHeight, 150)
        
        OptionsList.Size = UDim2.new(1, 0, 0, totalExpandedHeight - baseHeight)
        DropdownFrame.Size = OptionsList.Visible and UDim2.new(0.96875, 0, 0, totalExpandedHeight) or UDim2.new(0.96875, 0, 0, 28)
    end)

    local optButtons = {}
    if isMulti then
        local controlRow = Instance.new("Frame", OptionsList)
        controlRow.Size = UDim2.new(1, 0, 0, 24)
        controlRow.BackgroundTransparency = 1
        
        local selectAll = Instance.new("TextButton", controlRow)
        selectAll.Size = UDim2.new(0.40, 0, 1, 0)
        selectAll.Position = UDim2.new(0.025, 0, 0, 0)
        selectAll.BackgroundColor3 = C.primary
        selectAll.Text = "Select All"
        selectAll.TextColor3 = Color3.fromRGB(255, 255, 255)
        selectAll.Font = Enum.Font.GothamMedium
        selectAll.TextSize = 11
        selectAll.AutoButtonColor = false
        Instance.new("UICorner", selectAll).CornerRadius = UDim.new(0, 6)

        local removeAll = Instance.new("TextButton", controlRow)
        removeAll.Size = UDim2.new(0.40, 0, 1, 0)
        removeAll.Position = UDim2.new(0.515, 0, 0, 0)
        removeAll.BackgroundColor3 = C.error_
        removeAll.Text = "Remove All"
        removeAll.TextColor3 = Color3.fromRGB(255, 255, 255)
        removeAll.Font = Enum.Font.GothamMedium
        removeAll.TextSize = 11
        removeAll.AutoButtonColor = false
        Instance.new("UICorner", removeAll).CornerRadius = UDim.new(0, 6)

        selectAll.MouseButton1Click:Connect(function()
            for _, opt in ipairs(optionsList) do
                currentTable[opt] = true
                if optButtons[opt] then optButtons[opt].TextColor3 = C.primary end
            end
            updateText()
            if callback then callback() end
        end)

        removeAll.MouseButton1Click:Connect(function()
            for _, opt in ipairs(optionsList) do
                currentTable[opt] = false
                if optButtons[opt] then optButtons[opt].TextColor3 = C.muted end
            end
            updateText()
            if callback then callback() end
        end)
    end

    for i, optName in ipairs(optionsList) do
        local OptionBtn = Instance.new("TextButton", OptionsList)
        OptionBtn.Size = UDim2.new(.98, 0, 0, 22)
        OptionBtn.BackgroundColor3 = C.bg
        OptionBtn.TextColor3 = C.muted
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.TextSize = 12
        OptionBtn.Text = "    " .. optName
        OptionBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptionBtn.LayoutOrder = i
        OptionBtn.AutoButtonColor = false
        Instance.new("UICorner", OptionBtn).CornerRadius = UDim.new(0, 4)
        optButtons[optName] = OptionBtn

        if isMulti then
            OptionBtn.TextColor3 = currentTable[optName] and C.primary or C.muted
            OptionBtn.MouseButton1Click:Connect(function()
                currentTable[optName] = not currentTable[optName]
                OptionBtn.TextColor3 = currentTable[optName] and C.primary or C.muted
                updateText() if callback then callback() end
            end)
        else
            OptionBtn.TextColor3 = (Settings[currentTable] == optName) and C.primary or C.muted
            OptionBtn.MouseButton1Click:Connect(function()
                Settings[currentTable] = optName
                for _, btn in pairs(optButtons) do btn.TextColor3 = C.muted end
                OptionBtn.TextColor3 = C.primary
                updateText() 
                OptionsList.Visible = false 
                DropdownFrame.Size = UDim2.new(0.96875, 0, 0, 28)
                if callback then callback(optName) end
            end)
        end
    end

    updateText()
    return DropdownFrame
end

-- ════════════════════════════════════════════════════════════════════
-- UI Instantiation & Initialization
-- ════════════════════════════════════════════════════════════════════

local MyUI = MiwaHub.CreateWindow(DynamicHeaderTitle)
local MainTab, SkillsTab, AutoTab, DungeonTab, TeleportsTab, SettingsTab, InfoTab

if IsMainGame then
    MainTab = MyUI:AddTab("Main")
    SkillsTab = MyUI:AddTab("Weapon Skills")
    AutoTab = MyUI:AddTab("Automation")
    DungeonTab = MyUI:AddTab("Dungeon Raid")
    TeleportsTab = MyUI:AddTab("Teleports")
    SettingsTab = MyUI:AddTab("Settings")
    InfoTab = MyUI:AddTab("Info")

    MainTab:AddLabel("-- Auto Farm Mobs --")
    MainTab:AddToggle("Auto Farm Mobs", Settings.AutoFarmMobs, function(v) Settings.AutoFarmMobs = v saveConfig() end)
    MainTab:AddDropdown("Mob Selected", Settings.SelectedMobs, OrderedMobs, true, function() saveConfig() end)

    MainTab:AddLabel("-- Auto Farm Boss --")
    MainTab:AddToggle("Auto Farm Boss", Settings.AutoFarmBoss, function(v) Settings.AutoFarmBoss = v saveConfig() end)
    MainTab:AddDropdown("Boss Selected", Settings.SelectedBosses, OrderedBosses, true, function() saveConfig() end)

    MainTab:AddLabel("-- Auto Farm Raid Boss --")
    MainTab:AddToggle("Auto Farm Raid Boss", Settings.AutoFarmRaidBoss, function(v) Settings.AutoFarmRaidBoss = v saveConfig() end)
    MainTab:AddDropdown("Raid Boss Selected", Settings.SelectedRaidBosses, OrderedRaidBosses, true, function() saveConfig() end)

    MainTab:AddLabel("-- Auto Element Reroll --")
    MainTab:AddToggle("Auto Element Reroll", Settings.AutoRerollElement, function(v) Settings.AutoRerollElement = v saveConfig() end)
    MainTab:AddDropdown("Select Elements", Settings.SelectedElements, OrderedElements, true, function() saveConfig() end)

    MainTab:AddLabel("-- Auto Race Reroll --")
    MainTab:AddToggle("Auto Race Reroll", Settings.AutoRerollRace, function(v) Settings.AutoRerollRace = v saveConfig() end)
    MainTab:AddDropdown("Select Races", Settings.SelectedRaces, OrderedRaces, true, function() saveConfig() end)

    MainTab:AddLabel("-- Auto Bless Reroll --")
    MainTab:AddToggle("Auto Bless Reroll", Settings.AutoRerollBless, function(v) Settings.AutoRerollBless = v saveConfig() end)
    MainTab:AddDropdown("Select Blesses", Settings.SelectedBlesses, OrderedBlesses, true, function() saveConfig() end)
    MainTab:AddLabel("")

    AutoTab:AddLabel("-- Automations --")
    AutoTab:AddToggle("Auto Interact Altars", Settings.AutoAltar, function(v) Settings.AutoAltar = v saveConfig() end)
    AutoTab:AddToggle("Auto Collect Chomusuke And Gubby", Settings.AutoChomusuke, function(v) Settings.AutoChomusuke = v saveConfig() end)
    AutoTab:AddToggle("Auto Buy All Reroll Shop", Settings.AutoRerollShop, function(v) Settings.AutoRerollShop = v saveConfig() end)
    AutoTab:AddToggle("Auto Open Chest", Settings.AutoOpenChest, function(v) Settings.AutoOpenChest = v saveConfig() end)
    AutoTab:AddDropdown("Select Chests", Settings.SelectedChests, ChestOptions, true, function() saveConfig() end)
    
    AutoTab:AddLabel("-- Quest Masters --")
    AutoTab:AddButton("Talk to Sword Master", function() InteractWithMaster("241006") end)
    AutoTab:AddButton("Talk to Katana Master", function() InteractWithMaster("241007") end)
    AutoTab:AddButton("Talk to Buster Master", function() InteractWithMaster("241008") end)
    AutoTab:AddButton("Talk to Block Master", function() InteractWithMaster("241001") end)
    AutoTab:AddButton("Talk to Parry Master", function() InteractWithMaster("241002") end)

    DungeonTab:AddLabel("-- Auto Broken Expanse --")
    DungeonTab:AddToggle("Broken Expanse", Settings.BrokenExpanse, function(v) Settings.BrokenExpanse = v saveConfig() end)
    DungeonTab:AddDropdown("Select Difficulty", "RaidDifficulty", {"Common", "Hard", "Nightmare"}, false, function() saveConfig() end)
    DungeonTab:AddDropdown("Max Players Limit", "MaxPlayers", {"1", "2", "3"}, false, function(selected) Settings.MaxPlayers = tonumber(selected) or 1 saveConfig() end)

    TeleportsTab:AddLabel("-- Islands --")
    for _, loc in ipairs(TeleportLocations) do TeleportsTab:AddButton(loc.Name, function() RawTeleport(loc.Pos) end) end
    TeleportsTab:AddLabel("-- Upgrade NPC --")
    TeleportsTab:AddButton("Forge Master", function() NPC_Teleport("Master", "240401") end)
    TeleportsTab:AddButton("Identify", function() NPC_Teleport("Master", "240628") end)
    TeleportsTab:AddButton("SoulForge", function() NPC_Teleport("Other", "240611") end)
    TeleportsTab:AddButton("Ascension", function() NPC_Teleport("Other", "240627") end)
    TeleportsTab:AddLabel("-- NPC --")
    TeleportsTab:AddButton("Storm Chief", function() NPC_Teleport("Other", "240618") end)
    TeleportsTab:AddButton("Frost Chief", function() NPC_Teleport("Other", "240615") end)
    TeleportsTab:AddButton("Thunder Chief", function() NPC_Teleport("Other", "240617") end)
    TeleportsTab:AddButton("Flame Chief", function() NPC_Teleport("Other", "240616") end)
    TeleportsTab:AddLabel("-- Shop --")
    TeleportsTab:AddButton("Piece Shop", function() NPC_Teleport("Other", "240609") end)
    TeleportsTab:AddButton("Greedy Shop", function() NPC_Teleport("Other", "240603") end)
    TeleportsTab:AddButton("Reroll Shop", function() NPC_Teleport("Other", "240604") end)
    TeleportsTab:AddButton("Material Shop", function() NPC_Teleport("Other", "240608") end)
    TeleportsTab:AddButton("Recycle", function() NPC_Teleport("Other", "240610") end)
    TeleportsTab:AddButton("Ruby Shop", function() NPC_Teleport("Other", "240629") end)
    TeleportsTab:AddLabel("")

elseif IsRaidGame then
    MainTab = MyUI:AddTab("Main")
    SkillsTab = MyUI:AddTab("Weapon Skills")
    SettingsTab = MyUI:AddTab("Settings")
    InfoTab = MyUI:AddTab("Info")

    MainTab:AddLabel("-- Auto Raid --")
    MainTab:AddToggle("Auto Raid", Settings.AutoRaid, function(v) Settings.AutoRaid = v saveConfig() end)
MainTab:AddLabel("-- Endless Tower Only --")
    MainTab:AddToggle("Auto Start / Retry", Settings.AutoRestart, function(v) 
        Settings.AutoRestart = v 
        if v then requestTowerStart() end
        saveConfig() 
    end)
    MainTab:AddToggle("Auto Input Highest Floor", Settings.AutoHighestFloor, function(v) 
        Settings.AutoHighestFloor = v 
        saveConfig() 
    end)
    StatusLabel = MainTab:AddLabel("Status: Awaiting Tower Event...")
end

if not SkillsTab then SkillsTab = MyUI:AddTab("Weapon Skills") end
SkillsTab:AddLabel("-- Weapon Skills --")
SkillsTab:AddToggle("Auto Skill Weapon", Settings.AutoSkill, function(v) Settings.AutoSkill = v saveConfig() end)
SkillsTab:AddLabel("")
for _, key in ipairs(SkillKeys) do SkillsTab:AddToggle(key.Name, Settings.Skills[key], function(v) Settings.Skills[key] = v saveConfig() end) end

if not SettingsTab then SettingsTab = MyUI:AddTab("Settings") end
SettingsTab:AddLabel("-- General Settings --")
SettingsTab:AddToggle("Fast Performance Mode", Settings.FastMode, function(v) Settings.FastMode = v applyFastMode(v) toggleFastModeListener(v) saveConfig() end)
SettingsTab:AddToggle("Minimize UI on Default Load", Settings.MinimizeOnDefault, function(v) Settings.MinimizeOnDefault = v saveConfig() end)
SettingsTab:AddButton("Reset All to Default", function() resetConfigToDefault() if _G.BahadeHubShutdown then _G.BahadeHubShutdown() end end)
SettingsTab:AddButton("Destroy UI", function() if _G.BahadeHubShutdown then _G.BahadeHubShutdown() end end)

if not InfoTab then InfoTab = MyUI:AddTab("Info") end
InfoTab:AddLabel("-- Discord Server --")
InfoTab:AddButton("Join Discord Server", function() safeCopy("https://discord.gg/yu3jwmD6R8") end)
InfoTab:AddLabel("")
InfoTab:AddLabel("-- Premium Keys --")
InfoTab:AddButton("Buy Premium Keys Via Sell Auth", function() safeCopy("Soon!") end)
InfoTab:AddButton("Buy Premium Keys Via Roblox", function() safeCopy("Soon!") end)

-- Skill Combo Processor
local SkillTickClock = 0
local CurrentComboIndex = 1

local function executeComboSequence(dt)
    if not Settings.AutoSkill then return end
    SkillTickClock += dt
    local currentKey = SkillKeys[CurrentComboIndex]
    
    if currentKey then
        if Settings.Skills[currentKey] then
            VIM:SendKeyEvent(true, currentKey, false, game)
            VIM:SendKeyEvent(false, currentKey, false, game)
        end
        CurrentComboIndex += 1
    else
        if SkillTickClock >= Settings.SkillDelay then 
            SkillTickClock = 0 
            CurrentComboIndex = 1 
        end
    end
end

-- Main Stepped Target Execution Frame Loop
local CachedAltarsContainer = nil
local CachedEnemyService = nil

SteppedConnection = RunService.Stepped:Connect(function(_, deltaTime)
    if not ScriptRunning then return end
    
    if IsMainGame then
        if Settings.AutoChomusuke or Settings.AutoAltar or IsInteractingMaster or Settings.BrokenExpanse then CurrentLockedTarget = nil return end
        if Settings.AutoFarmBoss or Settings.AutoFarmRaidBoss or Settings.AutoFarmMobs then
            local char, hrp = getCharacter()
            if not char then CurrentLockedTarget = nil return end
            
            if hrp then 
                hrp.AssemblyLinearVelocity = Vector3.zero 
                hrp.AssemblyAngularVelocity = Vector3.zero 
            end

            if CurrentLockedTarget then
                local humanoid = CurrentLockedTarget:FindFirstChildOfClass("Humanoid")
                if (humanoid and humanoid.Health <= 0.1) or not CurrentLockedTarget.Parent then CurrentLockedTarget = nil end
            end
            if not CurrentLockedTarget then CurrentLockedTarget = getActiveTarget() end
            if CurrentLockedTarget then
                equipWeapon(char)
                local targetPart = CurrentLockedTarget:FindFirstChild("HumanoidRootPart") or CurrentLockedTarget.PrimaryPart or CurrentLockedTarget:FindFirstChildWhichIsA("BasePart")
                char:PivotTo((targetPart and targetPart.CFrame or CurrentLockedTarget:GetPivot()) * CachedFarmOffset)
                executeComboSequence(deltaTime)
            end
        else
            CurrentLockedTarget = nil
        end
    end

    if IsRaidGame and Settings.AutoRaid then
        local char, hrp = getCharacter()
        if not hrp then return end

        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        local targetEnemy = nil

        if not CachedAltarsContainer or not CachedAltarsContainer.Parent then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name:find("DragonAltars_EnemyService") then
                    CachedAltarsContainer = obj
                    break
                end
            end
        end

        if CachedAltarsContainer then
            local children = CachedAltarsContainer:GetChildren()
            if #children > 0 then targetEnemy = children[1] end
        end

        if not CachedEnemyService or not CachedEnemyService.Parent then
            CachedEnemyService = Workspace:FindFirstChild("EnemyService")
        end
        
        if CachedEnemyService and not targetEnemy then
            for _, enemy in ipairs(CachedEnemyService:GetChildren()) do
                local hum = enemy:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0.1 then
                    targetEnemy = enemy
                    break
                end
            end
        end

        if targetEnemy then
            if StatusLabel then StatusLabel.Text = "Status: Attacking " .. targetEnemy.Name end
            equipWeapon(char)
            char:PivotTo((targetEnemy:IsA("Model") and targetEnemy:GetPivot() or targetEnemy.CFrame) * CachedFarmOffset)
            executeComboSequence(deltaTime)
        else
            if StatusLabel then StatusLabel.Text = "Status: Waiting for Entities..." end
        end
    end
end)

-- Shutdown Function
_G.BahadeHubShutdown = function()
    ScriptRunning = false 
    if HeartbeatConnection then HeartbeatConnection:Disconnect() end
    if SteppedConnection then SteppedConnection:Disconnect() end
    if applyFastMode then applyFastMode(false) end
    if toggleFastModeListener then toggleFastModeListener(false) end
    if DescendantAddedConnection then DescendantAddedConnection:Disconnect() end
    CachedAltarsContainer = nil
    CachedEnemyService = nil
    TargetCache = {}
    pcall(function() GuiService:SetGameplayPausedNotificationEnabled(true) end)
    if MyUI and MyUI.ScreenGui then pcall(function() MyUI.ScreenGui:Destroy() end) end
end