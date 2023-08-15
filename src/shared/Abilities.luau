local Abilities = {}

--- Smoke: throw a smoke ability
type Smoke = { type: "Smoke" }
type UpDraft = { type: "UpDraft" }
type Dash = { type: "Dash" }
type Knifes = { type: "Knifes" }

type Flash = { type: "Flash" }

export type Jett = Smoke | UpDraft | Dash | Knifes
export type Pheonix = Flash

Abilities.Jett = table.freeze({
	Smoke = { type = "Smoke" } :: Smoke,
	UpDraft = { type = "UpDraft" } :: UpDraft,
	Dash = { type = "Dash" } :: Dash,
	Knifes = { type = "Knifes" } :: Knifes,
})

Abilities.Pheonix = table.freeze({
	Flash = { type = "Flash" } :: Flash,
})

export type Abilities = Jett | Pheonix -- | otherAgents

return Abilities
