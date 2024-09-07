local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

--print("Quafe_Options is unfinished")

----------------------------------------------------------------
--> Template
----------------------------------------------------------------

local function NewPanel(frame, name)
    local DummyPanel = CreateFrame("Frame", name, InterfaceOptionsFrame)
    DummyPanel: SetSize(396,400)
    --DummyPanel.name
    DummyPanel.parent = "Quafe UI"

    local Title = F.Create.Font(DummyPanel, "ARTWORK", C.Font.Txt, 28, nil, {r=250,g=213,b=62},1)
    Title: SetPoint("TOPLEFT", DummyPanel, "TOPLEFT", 10, -10)

    return DummyPanel
end

----------------------------------------------------------------
--> Options
----------------------------------------------------------------

-- When the player clicks okay, run this function.
-- panel.okay = function (self) SC_ChaChingPanel_Close(); end;

-- When the player clicks cancel, run this function.
-- panel.cancel = function (self)  SC_ChaChingPanel_CancelOrLoad();  end;

