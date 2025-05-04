config = {
  salvarAttachsDb = true, -- SALVAR OS ATTACHS APLICADOS NO BANCO DE DADOS
  perderAttachsAoMorrer = true,
}

blips = {
  { x = 461.41, y = -983.05, z = 30.69, perms = { "owner.permissao" }, pagarPelaModificacao = false, usarItens = false }
}

comandos = {
  { comando = "", perms = { "owner.permissao" } },
  { comando = "", perms = { }, pagarPelaModificacao = true, usarItens = true },
  { comando = "", perms = { }, pagarPelaModificacao = true, usarItens = false }
}

priceAttachs = {
  mira = 1000,
  cano = 2000,
  grip = 3000,
  lanterna = 4000,
  carregador = 5000,
  municao = 6000,
  textura = 3500,
  textura_slide = 2000,
  cor = 1000,
}

attachsDefault = {
  ["mira"] = { text = "MIRA", price = 1000, imgCategoria = "https://media.diamondrp.ir/vipmenu/ilpm03u.png" },
  ["cano"] = { text = "CANO", price = 2000, imgCategoria = "https://media.diamondrp.ir/vipmenu/tM06Mum.png" },
  ["grip"] = { text = "GRIP", price = 3000, imgCategoria = "https://media.diamondrp.ir/vipmenu/vbRBfZK.png" },
  ["lanterna"] = { text = "LANTERNA", price = 4000, imgCategoria = "https://media.diamondrp.ir/vipmenu/HWKYHIk.png" },
  ["carregador"] = { text = "CARREGADOR", price = 5000, imgCategoria = "https://media.diamondrp.ir/vipmenu/LRE7qiJ.png" },
  ["municao"] = { text = "MUNIÇÃO", price = 6000, imgCategoria = "https://media.diamondrp.ir/vipmenu/dfamhES.png" },
  ["cor"] = { text = "COR DA ARMA", price = 1000, imgCategoria = "https://media.diamondrp.ir/vipmenu/dTVpWsH.png" },
  ["textura"] = { text = "TEXTURA DA ARMA", price = 3500, imgCategoria = "https://media.diamondrp.ir/vipmenu/9zpIjgv.png" },
  ["textura_slide"] = { text = "TEXTURA DO SLIDE", price = 2000, imgCategoria = "https://media.diamondrp.ir/vipmenu/9zpIjgv.png" },
}

attachsItens = {
  mira = "attmira",
  cano = "attcano",
  grip = "attgrip",
  lanterna = "attlanterna",
  carregador = "attcarregador",
  textura = "atttextura",
  textura_slide = "atttexturaslide",
  cor = "attlatatinta",
}