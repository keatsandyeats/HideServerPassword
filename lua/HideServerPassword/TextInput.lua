local kHiddenChar = "•"

local oldInit = TextInput.Initialize
function TextInput:Initialize()
    oldInit(self)
    
    self.secretText = ""

end

function TextInput:SetIsSecret(isSecret)
    self.isSecret = isSecret
end

function TextInput:GetIsSecret()
    return self.isSecret or false
end

function TextInput:GetSecretText()
    return self.secretText
end

function TextInput:GetValue()
    if self:GetIsSecret() then
        return self:GetSecretText()
    end
    
    return FormElement.GetValue(self)
end

function TextInput:AddCharacter(character)

    if not self.numbersOnly or IsANumber(self, character) then
        self:SetValue(self.text:GetWideText() .. character)
        
        if self:GetIsSecret() then 
            local currentText = self.text:GetText()
            local length = #currentText
            local oldText = currentText:sub(1, length-1)
            local newChar = currentText:sub(length)
            
            self.secretText = self.secretText .. newChar
            
            self:SetValue(oldText .. kHiddenChar)
        end
    end
    
end

function TextInput:RemoveCharacter()
    local currentText = self.text:GetWideText()
    local length = #currentText
    self:SetValue(currentText:sub(1, length - 1))
    
    if self:GetIsSecret() then
        self.secretText = self.secretText:sub(1, length - 1)
    end
end