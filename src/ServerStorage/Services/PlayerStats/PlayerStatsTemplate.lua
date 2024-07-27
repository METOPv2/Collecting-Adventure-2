export type PlayerStats = {
	Inventory: {},
	set: (self: {}, key: any, value: any) -> (),
	insert: (self: {}, key: any, value: {}) -> (),
	get: (self: {}, key: string) -> any,
	remove: (self: {}, key: string) -> (),
	Destroy: (self: {}) -> (),
}

return {
	Inventory = {},
}
