local function JoinServer(self)

    local selectedServer = MainMenu_GetSelectedServer()
    if selectedServer ~= nil then 
          

        if selectedServer < 0 then
            MainMenu_JoinSelected()
            
        elseif MainMenu_GetSelectedIsFull() and not MainMenu_ForceJoin() then
            
            self.autoJoinWindow:SetIsVisible(true)
            self.autoJoinText:SetText(ToString(MainMenu_GetSelectedServerName()))
            
            if MainMenu_GetSelectedIsFullWithNoRS() then          
                self.autoJoinWindow.forceJoin:SetIsVisible(false)
            else                
                self.autoJoinWindow.forceJoin:SetIsVisible(true)
            end
            
        else
           
            MainMenu_JoinSelected()
            
        end
    end
    
end

function GUIMainMenu:CreatePasswordPromptWindow()

    self.passwordPromptWindow = self:CreateWindow()
    local passwordPromptWindow = self.passwordPromptWindow
    passwordPromptWindow:SetWindowName("ENTER PASSWORD")
    passwordPromptWindow:SetInitialVisible(false)
    passwordPromptWindow:SetIsVisible(false)
    passwordPromptWindow:DisableResizeTile()
    passwordPromptWindow:DisableSlideBar()
    passwordPromptWindow:DisableContentBox()
    passwordPromptWindow:SetCSSClass("passwordprompt_window")
    passwordPromptWindow:DisableCloseButton()
    passwordPromptWindow:SetLayer(kGUILayerMainMenuDialogs)
        
    local passwordForm = CreateMenuElement(passwordPromptWindow, "Form", false)
    passwordForm:SetCSSClass("passwordprompt")
    
    local textinput = passwordForm:CreateFormElement(Form.kElementType.TextInput, "PASSWORD", "")
    textinput:SetCSSClass("serverpassword")    
    textinput:SetIsSecret(true) -- Hide Server Password change
    textinput:AddEventCallbacks({
        OnEscape = function(self)
            passwordPromptWindow:SetIsVisible(false) 
        end
    })
    
    local descriptionText = CreateMenuElement(passwordPromptWindow.titleBar, "Font", false)
    descriptionText:SetCSSClass("passwordprompt_title")
    descriptionText:SetText(Locale.ResolveString("PASSWORD"))
    
    local joinServer = CreateMenuElement(passwordPromptWindow, "MenuButton")
    joinServer:SetCSSClass("bottomcenter")
    joinServer:SetText(Locale.ResolveString("JOIN"))
    
    local function SubmitPassword()
        local formData = passwordForm:GetFormData()
        MainMenu_SetSelectedServerPassword(formData.PASSWORD)
        passwordPromptWindow:SetIsVisible(false)
        JoinServer(self)
    end
    
    joinServer:AddEventCallbacks({ OnClick = SubmitPassword })
    passwordPromptWindow:AddEventCallbacks({ 
    
        OnBlur = function(self) self:SetIsVisible(false) end,        
        OnEnter = SubmitPassword,
        OnShow = function(self) GetWindowManager():HandleFocusBlur(self, textinput) end,

    })
    
end