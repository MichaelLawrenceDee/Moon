--Not yet finalized values
--Custom constants
EFFECT_STAGE							=388		--
EFFECT_CANNOT_BE_EVOLUTE_MATERIAL		=389		--
EFFECT_PANDEMONIUM						=726
EFFECT_STABLE							=765
EFFECT_CANNOT_BE_POLARITY_MATERIAL		=766
TYPE_EVOLUTE							=0x100000000
TYPE_PANDEMONIUM						=0x200000000
TYPE_POLARITY							=0x400000000

--overwrite constants
TYPE_EXTRA=TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK+TYPE_EVOLUTE+TYPE_POLARITY

--overwrite functions
local get_rank=Card.GetRank
Card.GetRank=function(c)
	if c:IsHasEffect(EFFECT_STAGE) then return 0 end
	return get_rank(c)
end
local get_orig_rank=Card.GetOriginalRank
Card.GetOriginalRank=function(c)
	if c:IsHasEffect(EFFECT_STAGE) then return 0 end
	return get_orig_rank(c)
end
local prev_rank_field=Card.GetPreviousRankOnField
Card.GetPreviousRankOnField=function(c)
	if c:IsHasEffect(EFFECT_STAGE) then return 0 end
	return prev_rank_field(c)
end
local is_rank=Card.IsRank
Card.IsRank=function(c,rk)
	if c:IsHasEffect(EFFECT_STAGE) then return false end
	return is_rank(c,rk)
end
local is_rank_below=Card.IsRankBelow
Card.IsRankBelow=function(c,rk)
	if c:IsHasEffect(EFFECT_STAGE) then return false end
	return is_rank_below(c,rk)
end
local is_rank_above=Card.IsRankAbove
Card.IsRankAbove=function(c,rk)
	if c:IsHasEffect(EFFECT_STAGE) then return false end
	return is_rank_above(c,rk)
end
local get_type=Card.GetType
Card.GetType=function(c,scard,sumtype,p)
	local tpe=get_type(c,scard,sumtype,p)
	if c:IsHasEffect(EFFECT_STAGE) and tpe&TYPE_XYZ>0 then
		tpe=(tpe|TYPE_EVOLUTE)~TYPE_XYZ
	end
	if c:IsHasEffect(EFFECT_PANDEMONIUM) and tpe&TYPE_PENDULUM>0 then
		tpe=(tpe|TYPE_PANDEMONIUM)~TYPE_PENDULUM
		if c:IsLocation(LOCATION_PZONE) then
			tpe=(tpe|TYPE_TRAP)~TYPE_SPELL
		end
	end
	if c:IsHasEffect(EFFECT_STABLE) and tpe&TYPE_SYNCHRO>0 then
		tpe=(tpe|TYPE_POLARITY)~TYPE_SYNCHRO
	end
	return tpe
end
local is_type=Card.IsType
Card.IsType=function(c,tpe,scard,sumtype,p)
	return c:GetType(scard,sumtype,p)&tpe~=0
end
local get_orig_type=Card.GetOriginalType
Card.GetOriginalType=function(c)
	local tpe=get_orig_type(c)
	if c:IsHasEffect(EFFECT_STAGE) then
		tpe=(tpe|TYPE_EVOLUTE)~TYPE_XYZ
	end
	if c:IsHasEffect(EFFECT_PANDEMONIUM) then
		tpe=(tpe|TYPE_PANDEMONIUM)~TYPE_PENDULUM
	end
	if c:IsHasEffect(EFFECT_STABLE) then
		tpe=(tpe|TYPE_POLARITY)~TYPE_SYNCHRO
	end
	return tpe
end
local get_prev_type_field=Card.GetPreviousTypeOnField
Card.GetPreviousTypeOnField=function(c)
	local tpe=get_prev_type_field(c)
	if c:IsHasEffect(EFFECT_STAGE) and get_prev_type_field(c)&TYPE_XYZ>0 then
		tpe=(tpe|TYPE_EVOLUTE)~TYPE_XYZ
	end
	if c:IsHasEffect(EFFECT_PANDEMONIUM) and tpe&TYPE_PENDULUM>0 then
		tpe=(tpe|TYPE_PANDEMONIUM)~TYPE_PENDULUM
		if tpe&TYPE_SPELL>0 then
			tpe=(tpe|TYPE_TRAP)~TYPE_SPELL
		end
	end
	if c:IsHasEffect(EFFECT_STABLE) and get_prev_type_field(c)&TYPE_SYNCHRO>0 then
		tpe=(tpe|TYPE_POLARITY)~TYPE_SYNCHRO
	end
	return tpe
end
local get_level=Card.GetLevel
Card.GetLevel=function(c)
	if c:IsHasEffect(EFFECT_STABLE) then return 0 end
	return get_level(c)
end
local get_syn_level=Card.GetSynchroLevel
GetSynchroLevel=function(c,sc)
	if c:IsHasEffect(EFFECT_STABLE) then return 0 end
	return get_syn_level(c,sc)
end
local get_rit_level=Card.GetRitualLevel
Card.GetRitualLevel=function(c,rc)
	if c:IsHasEffect(EFFECT_STABLE) then return 0 end
	return get_rit_level(c,rc)
end
local get_orig_level=Card.GetOriginalLevel
Card.GetOriginalLevel=function(c)
	if c:IsHasEffect(EFFECT_STABLE) then return 0 end
	return get_orig_level(c)
end
local is_xyz_level=Card.IsXyzLevel
Card.IsXyzLevel=function(c,xyz,lv)
	if c:IsHasEffect(EFFECT_STABLE) then return false end
	return is_xyz_level(c,xyz,lv)
end
local get_prev_level_field=Card.GetPreviousLevelOnField
Card.GetPreviousLevelOnField=function(c)
	if c:IsHasEffect(EFFECT_STABLE) then return 0 end
	return get_prev_level_field(c)
end
local is_level=Card.IsLevel
Card.IsLevel=function(c,lv)
	if c:IsHasEffect(EFFECT_STABLE) then return false end
	return is_level(c,lv)
end
local is_level_below=Card.IsLevelBelow
Card.IsLevelBelow=function(c,lv)
	if c:IsHasEffect(EFFECT_STABLE) then return false end
	return is_level_below(c,lv)
end
local is_level_above=Card.IsLevelAbove
Card.IsLevelAbove=function(c,lv)
	if c:IsHasEffect(EFFECT_STABLE) then return false end
	return is_level_above(c,lv)
end

--Custom Functions
--Evolutes
function Card.GetStage(c)
	if not c:IsHasEffect(EFFECT_STAGE) then return 0 end
	local te=c:GetCardEffect(EFFECT_STAGE)
	if type(te:GetValue())=='function' then
		return te:GetValue()(te,c)
	else
		return te:GetValue()
	end
end
function Card.IsStage(c,stage)
	return c:GetStage()==stage
end
function Card.IsCanBeEvoluteMaterial(c,ec)
	if c:GetLevel()<=0 and c:GetRank()<=0 and not c:IsStatus(STATUS_NO_LEVEL) then return false end
	local tef={c:GetCardEffect(EFFECT_CANNOT_BE_EVOLUTE_MATERIAL)}
	for _,te in ipairs(tef) do
		if te:GetValue()(te,ec) then return false end
	end
	return true
end
function Auxiliary.AddEvoluteProc(c,echeck,stage,...)
	--echeck - extra check after everything is settled, stage - Evolute "level"
	--... format - any number of materials + optional material - min, max (min can be 0, max can be nil which will set it to 99)	use aux.TRUE for generic materials
	if c:IsStatus(STATUS_COPYING_EFFECT) then return end
	local t={...}
	local reqmats={}
	local extramat,min,max
	if type(t[#t])=='number' then
		max=t[#t]
		table.remove(t)
		if type(t[#t])=='number' then
			min=t[#t]
			extramat=t[#t-1]
			table.remove(t)
		else
			min=max
			max=99
			extramat=t[#t]
		end
		table.remove(t)
	end
	if not extramat then extramat,min,max=aux.FALSE,0,0 end
	c:EnableCounterPermit(0x91)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_STAGE)
	e1:SetValue(Auxiliary.StageVal(stage))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.EvoluteCondition(echeck,extramat,min,max,...))
	e2:SetTarget(Auxiliary.EvoluteTarget(echeck,extramat,min,max,...))
	e2:SetOperation(Auxiliary.EvoluteOperation)
	e2:SetValue(SUMMON_TYPE_SPECIAL+388)
	c:RegisterEffect(e2)
	if not Evochk then
		Evochk=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(Auxiliary.EvoluteCounter)
		Duel.RegisterEffect(ge1,0)
	end
end
function Auxiliary.StageVal(stage)
	return	function(e,c)
				local stage=stage
				--insert modifications here
				return stage
			end
end
function Auxiliary.EvoluteMatFilter(c,ec,tp,...)
	if c:IsFacedown() or not c:IsCanBeEvoluteMaterial(ec) then return false end
	for _,f in ipairs({...}) do
		if f(c,ec,tp) then return true end
	end
	return false
end
function Auxiliary.EvoluteValue(c)
	local lv=c:GetLevel()
	local rk=c:GetRank()
	if lv>0 or c:IsStatus(STATUS_NO_LEVEL) then
		return lv+0x10000*rk
	else
		return rk+0x10000*lv
	end
end
function Auxiliary.EvolCheckRecursive(c,tp,mg,sg,ec,stage,echeck,extramat,min,max,f,...)
	if not f(c,ec,tp,sg) then return false end
	--if sg:CheckWithSumGreater(Auxiliary.EvoluteValue,stage+1) then return false end
	sg:AddCard(c)
	local res
	if ... then
		res=mg:IsExists(Auxiliary.ExEvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,echeck,extramat,min,max,Group.CreateGroup())
	else
		if min>0 then
			res=mg:IsExists(Auxiliary.EvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,...)
		else
			res=(sg:CheckWithSumEqual(Auxiliary.EvoluteValue,stage,sg:GetCount(),sg:GetCount()) and (not echeck or echeck(sg,ec,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,ec)>0) 
				or (max>0 and mg:IsExists(Auxiliary.ExEvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,echeck,extramat,min,max,Group.CreateGroup()))
		end
	end
	sg:RemoveCard(c)
	return res
end
function Auxiliary.ExEvolCheckRecursive(c,tp,mg,sg,ec,stage,echeck,extramat,min,max,sg2)
	if not extramat(c,ec,tp,sg,sg2) then return false end
	sg:AddCard(c)
	sg2:AddCard(c)
	local res
	if sg2:GetCount()<min then
		res=mg:IsExists(Auxiliary.ExEvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,echeck,extramat,min,max,sg2)
	elseif sg2:GetCount()<max then
		res=(sg:CheckWithSumEqual(Auxiliary.EvoluteValue,stage,sg:GetCount(),sg:GetCount()) and (not echeck or echeck(sg,ec,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,ec)>0) 
			or mg:IsExists(Auxiliary.ExEvolCheckRecursive,1,sg,tp,mg,sg,ec,stage,echeck,extramat,min,max,sg2)
	else
		res=sg:CheckWithSumEqual(Auxiliary.EvoluteValue,stage,sg:GetCount(),sg:GetCount()) and (not echeck or echeck(sg,ec,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,ec)>0
	end
	sg:RemoveCard(c)
	sg2:RemoveCard(c)
	return res
end
function Auxiliary.EvoluteCondition(echeck,extramat,min,max,...)
	local funs={...}
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local stage=c:GetStage()
				local mg=Duel.GetMatchingGroup(Auxiliary.EvoluteMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,table.unpack(funs),extramat)
				local sg=Group.CreateGroup()
				return mg:IsExists(Auxiliary.EvolCheckRecursive,1,nil,tp,mg,sg,c,stage,echeck,extramat,min,max,table.unpack(funs))
			end
end
function Auxiliary.EvoluteTarget(echeck,extramat,min,max,...)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.EvoluteMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,table.unpack(funs),extramat)
				local ct=#funs
				local stage=c:GetStage()
				local sg
				local sg2
				local tempfun
				::restart::
				sg=Group.CreateGroup()
				sg2=Group.CreateGroup()
				tempfun={table.unpack(funs)}
				while sg:GetCount()<ct+max do
					local cg
					if #tempfun>0 then
						cg=mg:Filter(Auxiliary.EvolCheckRecursive,sg,tp,mg,sg,c,stage,echeck,extramat,min,max,table.unpack(tempfun))
					elseif max>0 then
						cg=mg:Filter(Auxiliary.ExEvolCheckRecursive,sg,tp,mg,sg,c,stage,echeck,extramat,min,max,sg2)
					else
						cg=Group.CreateGroup()
					end
					if cg:GetCount()==0 then break end
					local tc=cg:SelectUnselect(sg,tp,true,true)
					if not tc then break end
					table.remove(tempfun,1)
					if not sg:IsContains(tc) then
						sg:AddCard(tc)
						if #tempfun<=0 then
							sg2:AddCard(tc)
						end
					end
				end
				if sg:GetCount()>=ct+min then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else
					if sg:GetCount()>0 then goto restart end
					return false
				end
			end
end
function Auxiliary.EvoluteOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x10000000)
	g:DeleteGroup()
end
function Auxiliary.ECSumFilter(c)
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL+388 and c:IsType(TYPE_EVOLUTE)
end
function Auxiliary.EvoluteCounter(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=eg:Filter(Auxiliary.ECSumFilter,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x91,tc:GetStage())
		tc=g:GetNext()
	end
end

--Pandemoniums
function Auxiliary.PendCondition()
	return	function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz or not rpz:IsType(TYPE_PENDULUM) or Duel.GetFlagEffect(tp,10000000)>0 then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(Auxiliary.PaConditionFilter,1,nil,e,tp,lscale,rscale)
			end
end
function Auxiliary.EnablePandemoniumAttribute(c,regfield,reghand,desc)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_PANDEMONIUM)
	c:RegisterEffect(e0)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(1074)
	end
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(Auxiliary.PandCondition)
	e1:SetOperation(Auxiliary.PandOperation)
	e1:SetValue(SUMMON_TYPE_SPECIAL+726)
	c:RegisterEffect(e1)
	--register by default
	if regfield==nil or regfield then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1160)
		e2:SetCondition(Auxiliary.PandActHandCon)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetTarget(Auxiliary.PandActTarget)
		e2:SetRange(LOCATION_SZONE)
		e2:SetLabel(LOCATION_SZONE)
		e2:SetValue(LOCATION_PZONE)
		c:RegisterEffect(e2)
		--set
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_MONSTER_SSET)
		--e3:SetValue(TYPE_TRAP+TYPE_PANDEMONIUM)
		e3:SetValue(TYPE_TRAP+TYPE_PENDULUM) --by default, it minuses PENDULUM and adds PANDEMONIUM
		c:RegisterEffect(e3)
	end
	if reghand==nil or reghand then
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(1160)
		e4:SetType(EFFECT_TYPE_ACTIVATE)
		e4:SetCode(EVENT_FREE_CHAIN)
		e4:SetRange(LOCATION_HAND)
		e4:SetLabel(LOCATION_HAND)
		e4:SetTarget(Auxiliary.PandActTarget)
		e4:SetValue(LOCATION_PZONE)
		c:RegisterEffect(e4)
	end
end
function Auxiliary.PandActTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then (e:GetLabel()~=LOCATION_HAND or e:GetHandler():IsHasEffect(EFFECT_TRAP_ACT_IN_HAND)) 
		and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
	e:GetHandler():RegisterFlagEffect(EFFECT_STAGE+1,RESET_EVENT+0x1fe0000,0,0)
end
function Auxiliary.PaConditionFilter(c,e,tp,lscale,rscale)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PANDEMONIUM)))
		and (lv>lscale and lv<rscale) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+726,tp,false,false)
		and not c:IsForbidden()
end
function Auxiliary.PandCondition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,10000000)>0 then return false end
	local lscale=c:GetLeftScale()
	local rscale=c:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(Auxiliary.PaConditionFilter,1,nil,e,tp,lscale,rscale)
end
function Auxiliary.PandOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local lscale=c:GetLeftScale()
	local rscale=c:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(Auxiliary.PaConditionFilter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(Auxiliary.PaConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale)
	end
	ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
	ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	while true do
		local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		local ct=ft
		if ct1>ft1 then ct=math.min(ct,ft1) end
		if ct2>ft2 then ct=math.min(ct,ft2) end
		local loc=0
		if ft1>0 then loc=loc+LOCATION_HAND end
		if ft2>0 then loc=loc+LOCATION_EXTRA end
		local g=tg:Filter(Card.IsLocation,sg,loc)
		if g:GetCount()==0 or ft==0 then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Group.SelectUnselect(g,sg,tp,true,true)
		if not tc then break end
		if sg:IsContains(tc) then
			sg:RemoveCard(tc)
			if tc:IsLocation(LOCATION_HAND) then
				ft1=ft1+1
			else
				ft2=ft2+1
			end
			ft=ft+1
		else
			sg:AddCard(tc)
			if tc:IsLocation(LOCATION_HAND) then
				ft1=ft1-1
			else
				ft2=ft2-1
			end
			ft=ft-1
		end
	end
	if sg:GetCount()>0 then
		Duel.RegisterFlagEffect(tp,10000000,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		Duel.HintSelection(Group.FromCards(c))
		Duel.Destroy(c,REASON_COST)
	end
end

--Polarities
function Card.GetStability(c)
	if not c:IsHasEffect(EFFECT_STABLE) then return 0 end
	local te=c:GetCardEffect(EFFECT_STABLE)
	if type(te:GetValue())=='function' then
		return te:GetValue()(te,c)
	else
		return te:GetValue()
	end
end
function Card.IsStability(c,stability)
	return c:GetStability()==stability
end
function Card.IsCanBePolarityMaterial(c,ec)
	if c:GetLevel()<=0 and not c:IsStatus(STATUS_NO_LEVEL) then return false end
	local tef={c:GetCardEffect(EFFECT_CANNOT_BE_POLARITY_MATERIAL)}
	for _,te in ipairs(tef) do
		if te:GetValue()(te,ec) then return false end
	end
	return true
end
function Auxiliary.AddPolarityProc(c,stability,f1,f2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_STABLE)
	e1:SetValue(Auxiliary.StabilityVal(stability))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(Auxiliary.PolarityCondition(f1,f2))
	e2:SetTarget(Auxiliary.PolarityTarget(f1,f2))
	e2:SetOperation(Auxiliary.PolarityOperation)
	e2:SetValue(SUMMON_TYPE_SPECIAL+765)
	c:RegisterEffect(e2)
end
function Auxiliary.StabilityVal(stability)
	return	function(e,c)
				local stability=stability
				--insert modifications here
				return stability
			end
end
function Auxiliary.PolarityMatFilter(c,ec,tp,...)
	if not c:IsCanBePolarityMaterial(ec) then return false end
	for _,f in ipairs({...}) do
		if f(c,ec,tp) then return true end
	end
	return false
end
function Auxiliary.PolarCheckRecursive1(g2,pc,stability)
	return	function(sg,e,tp,mg)
				local sg2=g2:Filter(aux.TRUE,sg)
				return Auxiliary.SelectUnselectGroup(sg2,e,tp,nil,nil,Auxiliary.PolarCheckRecursive2(sg,pc,stability),0)
			end
end
function Auxiliary.PolarCheckRecursive2(g1,pc,stability)
	return	function(g2,e,tp,mg)
				local sg=g1:Clone()
				sg:Merge(g2)
				return Duel.GetLocationCountFromEx(tp,tp,sg,pc)>0 and math.abs(g1:GetSum(Card.GetLevel)-g2:GetSum(Card.GetLevel))==stability
			end
end
function Auxiliary.PolarityCondition(f1,f2)
	local funs={...}
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local stability=c:GetStability()
				local mg=Duel.GetMatchingGroup(Auxiliary.PolarityMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,f1,f2)
				local g1=mg:Filter(f1,nil,c,tp)
				local g2=mg:Filter(f2,nil,c,tp)
				return Auxiliary.SelectUnselectGroup(g1,e,tp,nil,nil,Auxiliary.PolarCheckRecursive1(g2,c,stability),0)
			end
end
function Auxiliary.PolarityTarget(f1,f2)
	local funs={...}
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Auxiliary.PolarityMatFilter,tp,LOCATION_MZONE,0,nil,c,tp,f1,f2)
				local g1=mg:Filter(f1,nil,c,tp)
				local g2=mg:Filter(f2,nil,c,tp)
				local sg1=Auxiliary.SelectUnselectGroup(g1,e,tp,nil,nil,Auxiliary.PolarCheckRecursive1(g2,c,stability),1,tp,0,aux.TRUE)
				local mg2=mg:Sub(sg1)
				if not Auxiliary.PolarCheckRecursive1(g2,c,stability)(sg1,e,tp,mg2) then return false end
				local sg=sg1:Clone()
				local sg2=Group.CreateGroup()
				while true do
					local tg=g2:Sub(sg2)
					local mg=g:Filter(Auxiliary.SelectUnselectLoop,sg,sg,tg,e,tp,1,99,Auxiliary.PolarCheckRecursive2(sg1,c,stability))
					if mg:GetCount()<=0 then break end
					Duel.Hint(HINT_SELECTMSG,tp,0)
					local tc=mg:SelectUnselect(sg,tp,true,true)
					if not tc then break end
					if sg2:IsContains(tc) then
						sg2:RemoveCard(tc)
						sg:RemoveCard(tc)
					elseif not sg:IsContains(tc) then
						sg2:AddCard(tc)
						sg:AddCard(tc)
					end
				end
				local tg=g2:Sub(sg2)
				if Auxiliary.PolarCheckRecursive2(sg1,c,stability)(sg2,e,tp,tg) then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else
					return false
				end
			end
end
function Auxiliary.PolarityOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x40000000)
	g:DeleteGroup()
end
