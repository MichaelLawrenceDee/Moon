--Lunar Phase: Crying Pony Moon Burst
function c4242589.initial_effect(c)
		--pendulum summon
	aux.EnablePendulumAttribute(c)
	c:EnableCounterPermit(0x99,LOCATION_SZONE)
	-- Once per turn: You can shuffle 1 "Lunar Phase" monster you control into the Deck; 
	-- Special Summon 1 "Lunar Phase" monster with a different name from your Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c4242589.tg)
	e1:SetOperation(c4242589.op)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	
   	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,4242589)
	e3:SetCondition(c4242589.drcon)
	e3:SetTarget(c4242589.drtg)
	e3:SetOperation(c4242589.drop)
	c:RegisterEffect(e3)
		--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4242589,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c4242589.descon1)
	e4:SetTarget(c4242589.destg1)
	e4:SetOperation(c4242589.desop1)
	c:RegisterEffect(e4)

end

function c4242589.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeckAsCost()
		and Duel.IsExistingMatchingCard(c4242589.filter2,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c4242589.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4242589.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c4242589.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	local rg=Duel.SelectMatchingCard(tp,c4242589.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetCode())
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c4242589.op(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4242589.filter2,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end







function c4242589.cfilter(c,tp)
	return c:IsSetCard(0x666) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:GetReasonPlayer()~=tp and (c:IsReason(REASON_EFFECT) or (c:IsReason(REASON_BATTLE)))
end
function c4242589.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c4242589.cfilter,1,nil,tp)
end
function c4242589.dfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666)
end
function c4242589.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c4242589.dfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c4242589.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c4242589.dfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Draw(tp,ct,REASON_EFFECT)
end



--Effect 1 (Search) Code
function c4242589.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242589.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242589.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242589.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242589.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242589.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

