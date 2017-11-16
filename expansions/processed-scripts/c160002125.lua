--Stardust Cat Draco
function c160002125.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddEvoluteProc(c,nil,7,c160002125.filter1,c160002125.filter2)
end
function c160002125.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and (c:IsLevel(3) or c:IsRank(3))
end
function c160002125.filter2(c,ec,tp)
	return c:IsRace(RACE_WYRM) and (c:IsLevel(4) or c:IsRank(4))
end
