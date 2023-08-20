local ErrorMessages = {}

type OnCooldown = { type: "OnCooldown", message: "This ability is on cooldown" }
type NoMoreUses = { type: "NoMoreUses", message: "You run out of this ability" }
type CantUseAbility = { type: "CantUseAbility", message: "You can't use this ability" }

export type Error = OnCooldown | NoMoreUses | CantUseAbility

ErrorMessages.Jett = table.freeze({
	OnCooldown = { type = "OnCooldown", message = "This ability is on cooldown" } :: OnCooldown,
	NoMoreUses = { type = "NoMoreUses", message = "You run out of this ability" } :: NoMoreUses,
	CantUseAbility = { type = "CantUseAbility", message = "You can't use this ability" } :: CantUseAbility,
})

export type ErrorMessages = Error

return ErrorMessages
