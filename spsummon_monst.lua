
--c99995599
----[[
--When this card is Normal or Special Summoned: You can
--Special Summon 1 LIGHT Fairy monster from your hand or Deck.
----]]

function c99995599.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(99995599,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c99995599.sumtg)
    e1:SetOperation(c99995599.sumop)
    c:RegisterEffect(e1)
    local e1x=e1:Clone()
    e1x:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e1x)
end

function c99995599.filter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FAIRY)
    and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c99995599.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return 
    Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and Duel.IsExistingMatchingCard(c99995599.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
    end

    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end



function c99995599.sumop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local
    g=Duel.SelectMatchingCard(tp,c99995599.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
