return function()
	local ObjectAndTableConverterService = require(game.ServerStorage.Source.Services.ObjectAndTableConverterService)

	describe("ValueToObject", function()
		it("should return value base", function()
			local numberObject = ObjectAndTableConverterService.ValueToObject(2)
			expect(numberObject).to.be.ok()
			expect(typeof(numberObject)).to.equal("Instance")
			expect(numberObject.ClassName).to.equal("NumberValue")
			expect(numberObject.Value).to.equal(2)

			local stringObject = ObjectAndTableConverterService.ValueToObject("string")
			expect(stringObject).to.be.ok()
			expect(typeof(numberObject)).to.equal("Instance")
			expect(stringObject.ClassName).to.equal("StringValue")
			expect(stringObject.Value).to.equal("string")

			local boolObject = ObjectAndTableConverterService.ValueToObject(false)
			expect(boolObject).to.be.ok()
			expect(typeof(boolObject)).to.equal("Instance")
			expect(boolObject.ClassName).to.equal("BoolValue")
			expect(boolObject.Value).to.equal(false)
		end)
	end)

	describe("TableToObject", function()
		it("should return a new folder", function()
			local folder: Folder = ObjectAndTableConverterService.TableToObject({
				Gugugaga = 20,
				LolKekCheburek1448 = "YOYO",
			})
			expect(folder).to.be.ok()
			expect(typeof(folder)).to.equal("Instance")
			expect(folder.ClassName).to.equal("Folder")
		end)
	end)

	describe("FolderToTable", function()
		it("should return table", function()
			local folder = ObjectAndTableConverterService.TableToObject({
				Gugugaga = 1448,
				FreeCSGOskins = "​​3 топора",
			})
			local table = ObjectAndTableConverterService.FolderToTable(folder)
			expect(table).to.be.ok()
			expect(typeof(table)).to.equal("table")
		end)
	end)
end
