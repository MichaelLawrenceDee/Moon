--Toxic Waste Zone
function c90000033.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c90000033.value1)
	c:RegisterEffect(e1)
	--DEF Up
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--ATK Down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c90000033.value3)
	c:RegisterEffect(e3)
	--DEF Down
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--Negate Effect
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c90000033.condition5)
	e5:SetTarget(c90000033.target5)
	e5:SetOperation(c90000033.operation5)
	c:RegisterEffect(e5)
	--ATK/DEF 0
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c90000033.condition6)
	e6:SetTarget(c90000033.target6)
	e6:SetOperation(c90000033.operation6)
	c:RegisterEffect(e6)
end
function c90000033.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x14)
end
function c90000033.value1(e,c)
	return Duel.GetMatchingGroupCount(c90000033.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)*200
end
function c90000033.value3(e,c)
	return Duel.GetMatchingGroupCount(c90000033.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil)*-200
end
function c90000033.filter5_1(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x14)
end
function c90000033.condition5(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c90000033.filter5_1,1,nil,tp) and Duel.IsChainNegatable(ev)
end
function c90000033.filter5_2(c)
	return c:IsFaceup() and c:IsSetCard(0x14) and c:IsAbleToHand()
end
function c90000033.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c90000033.filter5_2,tp,LOCATION_SZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c90000033.filter5_2,tp,LOCATION_SZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c90000033.operation5(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tc)
		Duel.NegateActivation(ev)
	end
end
function c90000033.condition6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and rp~=tp and c:IsStatus(STATUS_ACTIVATED)
end
function c90000033.filter6(c)
	return c:IsFaceup() and not c:IsSetCard(0x14)
end
function c90000033.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000033.filter6,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c90000033.operation6(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c90000033.filter6,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000) 
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end