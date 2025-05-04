cfg = {}

cfg.comandoXenon = "xenon"
cfg.comandoNeon = "neon"
cfg.comandoSuspensao = "suspe"

cfg.apenasDonoAcessaXenon = true
cfg.apenasDonoAcessaNeon = true
cfg.apenasDonoAcessaSuspensao = true

cfg.permissaoParaInstalar = { existePermissao = true, permissoes = { "mecanico.permissao", "heat.permissao" } }

cfg.blipsShopMec = {
	-- {name='ATM', id=277, x=822.4, y=-952.07, z=22.1},
    { loc = { x = 822.48, y = -952.23, z = 22.09 }, perms = { "mecanico.permissao", "heat.permissao" } }
}

cfg.valores = {
	{ item = "suspensaoar", quantidade = 1, compra = 10000 },
	{ item = "moduloneon", quantidade = 1, compra = 5000 },
	{ item = "moduloxenon", quantidade = 1, compra = 5000 },
}
