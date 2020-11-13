
local function getID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local cod=_G[str]
	local id=tonumber(string.sub(str,2))
	return id,cod
end
local id,cid=getID()

--c99995599
----[[
--When this card is Normal or Special Summoned: You can
--Special Summon 1 LIGHT Fairy monster from your hand or Deck.
--When this card is Flip Summoned: You can send 1 face up level 8 or higher monster you control
--to the GY, then target 1 Level 7 or lower monster in your GY or that is banished; Special Summon that target
----]]


function c99995599.initial_effect(c)
--SpecialSummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(99995599,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetTarget(c99995599.sumtg)
    e1:SetOperation(c99995599.sumop)
    c:RegisterEffect(e1)
-- SpecialSummon alternative
    local e1x=e1:Clone()
    e1x:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e1x)

-- SpecialSummon with target
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(99995599,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    e2:SetCost(c99995599.spcost)
    e2:SetTarget(c99995599.sptg)
    e2:SetOperation(c99995599.spop)
    c:RegisterEffect(e2)

end
--filter 1
function c99995599.filter(c,e,tp)
    return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_FAIRY)
    and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--spsummom+alternative
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

--filter 2

function cid.costfilter(c,mmz)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(8) and c:IsAbleToGraveAsCost() and (mmz>0 or c:GetSequence()<5)
end
function cid.spfilter(c,e,tp)
	return c:IsLevelBelow(7) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

--spsummon with target
function cid.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.IsExistingMatchingCard(cid.costfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.costfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and cid.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cid.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(cid.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end