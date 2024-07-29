export type PlayerStats = {
	Inventory: {},
	set: (self: {}, key: any, value: any) -> (),
	insert: (self: {}, key: any, value: {}) -> (),
	increment: (self: {}, key: any, amount: number) -> (),
	get: (self: {}, key: string) -> any,
	remove: (self: {}, key: string) -> (),
	removeTable: (self: {}, key: string, t: {}) -> (),
	Destroy: (self: {}) -> (),
	Money: number,
}

return {
	Inventory = {},
	Money = 0,
}
