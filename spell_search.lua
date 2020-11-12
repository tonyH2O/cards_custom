
function c99995598.initial_effect(c)

    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(99995598,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,99995598)
    e1:SetTarget(c99995598.sctg)
    e1:SetOperation(c99995598.scop)
    c:RegisterEffect(e1)
end

function c99995598.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c99995598.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end


function c99995598.filter(c)
    return c:IsAbleToHand()
end

function c99995598.scop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local
    g=Duel.SelectMatchingCard(tp,c99995598.filter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end



