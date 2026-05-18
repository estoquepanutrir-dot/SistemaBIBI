const SPREADSHEET_ID = "1wf8IIv4YDQi2FnkSTC-DAGoDdXKEixOnpYXDeWFkhCo";

const ABAS = {
  PRODUTOS: "Produtos",
  VENDAS: "Vendas",
  SAIDAS_CAIXA: "SaidasCaixa",
  CAIXA: "Caixa",
};

const HEADERS = {
  PRODUTOS: ["nome", "codigo", "categoria", "preco", "quantidade", "fornecedor"],
  VENDAS: ["data", "hora", "itens", "subtotal", "desconto", "total", "pagamento"],
  SAIDAS_CAIXA: ["data", "hora", "valor", "motivo"],
  CAIXA: ["data", "hora", "valorInicial", "usuario"],
};

function doPost(e) {
  const headers = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "POST, GET, OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type",
    "Content-Type": "application/json; charset=utf-8",
  };

  try {
    const payload = JSON.parse(e.postData.contents || "{}");
    const action = payload.action || e.parameter.action || "";

    let result;

    switch (action) {
      case "getProdutos": result = getProdutos(); break;
      case "getVendas": result = getVendas(); break;
      case "addProduto": result = addProduto(payload.produto); break;
      case "updateProduto": result = updateProduto(payload.produto); break;
      case "deleteProduto": result = deleteProduto(payload.codigo); break;
      case "registrarVenda": result = registrarVenda(payload.venda, payload.carrinho); break;
      case "addSaidaCaixa": result = addSaidaCaixa(payload.saida); break;
      case "getSaidasCaixa": result = getSaidasCaixa(); break;
      case "abrirCaixa": result = abrirCaixa(payload.caixa); break;
      case "getCaixaAberto": result = getCaixaAberto(); break;
      default:
        result = { success: false, error: `Ação desconhecida: "${action}"` };
    }

    return ContentService
      .createTextOutput(JSON.stringify(result))
      .setMimeType(ContentService.MimeType.JSON);

  } catch (err) {
    Logger.log("[doPost] ERRO:", err.toString());
    return ContentService
      .createTextOutput(JSON.stringify({ success: false, error: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function doGet(e) {
  return ContentService
    .createTextOutput(JSON.stringify({ success: true, message: "Bibi Papelaria API v4" }))
    .setMimeType(ContentService.MimeType.JSON);
}

function getSheet(nomAba) {
  const ss = SpreadsheetApp.openById(SPREADSHEET_ID);
  const sheet = ss.getSheetByName(nomAba);
  if (!sheet) throw new Error(`Aba "${nomAba}" não encontrada na planilha.`);
  return sheet;
}

function sheetToObjects(sheet) {
  const data = sheet.getDataRange().getValues();
  if (data.length < 2) return [];
  const headers = data[0].map(h => String(h).trim());
  return data.slice(1).map(row => {
    const obj = {};
    headers.forEach((h, i) => { obj[h] = row[i] !== undefined ? String(row[i]) : ""; });
    return obj;
  });
}

function sanitize(val) {
  if (val === null || val === undefined) return "";
  return String(val).replace(/[=+\-@|]/g, (c) => c === "-" ? c : "");
}

function getProdutos() {
  try {
    const sheet = getSheet(ABAS.PRODUTOS);
    const data = sheetToObjects(sheet);
    return { success: true, data };
  } catch (err) {
    Logger.log("[getProdutos]", err);
    return { success: false, error: err.message };
  }
}

function addProduto(produto) {
  if (!produto || !produto.nome || !produto.codigo)
    return { success: false, error: "Campos 'nome' e 'codigo' são obrigatórios." };

  try {
    const sheet = getSheet(ABAS.PRODUTOS);
    const existentes = sheetToObjects(sheet);

    if (existentes.find(p => p.codigo === produto.codigo))
      return { success: false, error: `Código "${produto.codigo}" já cadastrado.` };

    const row = HEADERS.PRODUTOS.map(h => sanitize(produto[h] || ""));
    sheet.appendRow(row);

    return { success: true };
  } catch (err) {
    Logger.log("[addProduto]", err);
    return { success: false, error: err.message };
  }
}

function updateProduto(produto) {
  if (!produto || !produto.codigo)
    return { success: false, error: "Código do produto não informado." };

  try {
    const sheet = getSheet(ABAS.PRODUTOS);
    const data = sheet.getDataRange().getValues();
    const headers = data[0].map(h => String(h).trim());
    const colCodigo = headers.indexOf("codigo");

    if (colCodigo === -1) return { success: false, error: "Coluna 'codigo' não encontrada." };

    let atualizado = false;
    for (let i = 1; i < data.length; i++) {
      if (String(data[i][colCodigo]) === String(produto.codigo)) {
        const novaLinha = headers.map(h => sanitize(produto[h] !== undefined ? produto[h] : data[i][headers.indexOf(h)]));
        sheet.getRange(i + 1, 1, 1, headers.length).setValues([novaLinha]);
        atualizado = true;
        break;
      }
    }

    if (!atualizado) return { success: false, error: `Produto "${produto.codigo}" não encontrado.` };
    return { success: true };
  } catch (err) {
    Logger.log("[updateProduto]", err);
    return { success: false, error: err.message };
  }
}

function deleteProduto(codigo) {
  if (!codigo) return { success: false, error: "Código não informado." };

  try {
    const sheet = getSheet(ABAS.PRODUTOS);
    const data = sheet.getDataRange().getValues();
    const headers = data[0].map(h => String(h).trim());
    const colCodigo = headers.indexOf("codigo");

    if (colCodigo === -1) return { success: false, error: "Coluna 'codigo' não encontrada." };

    for (let i = data.length - 1; i >= 1; i--) {
      if (String(data[i][colCodigo]) === String(codigo)) {
        sheet.deleteRow(i + 1);
        return { success: true };
      }
    }

    return { success: false, error: `Produto "${codigo}" não encontrado.` };
  } catch (err) {
    Logger.log("[deleteProduto]", err);
    return { success: false, error: err.message };
  }
}

function getVendas() {
  try {
    const sheet = getSheet(ABAS.VENDAS);
    const data = sheetToObjects(sheet);
    return { success: true, data };
  } catch (err) {
    Logger.log("[getVendas]", err);
    return { success: false, error: err.message };
  }
}

function registrarVenda(venda, carrinho) {
  if (!venda || !Array.isArray(carrinho) || carrinho.length === 0)
    return { success: false, error: "Dados da venda inválidos." };

  const lock = LockService.getScriptLock();
  try {
    lock.waitLock(10000);

    const sheetProd = getSheet(ABAS.PRODUTOS);
    const prodData = sheetProd.getDataRange().getValues();
    const hdrs = prodData[0].map(h => String(h).trim());
    const colCod = hdrs.indexOf("codigo");
    const colQtd = hdrs.indexOf("quantidade");

    if (colCod === -1 || colQtd === -1)
      return { success: false, error: "Estrutura da aba Produtos inválida." };

    // Apenas itens NÃO avulsos deduzem estoque
    const itensCadastrados = carrinho.filter(i => !i.isAvulso);

    for (const item of itensCadastrados) {
      const rowIdx = prodData.findIndex((r, i) => i > 0 && String(r[colCod]) === String(item.codigo));
      if (rowIdx === -1) return { success: false, error: `Produto "${item.codigo}" não encontrado.` };
      const estoqueAtual = Number(prodData[rowIdx][colQtd]);
      if (item.qtd > estoqueAtual)
        return { success: false, error: `Estoque insuficiente para "${item.nome}" (disponível: ${estoqueAtual}).` };
    }

    for (const item of itensCadastrados) {
      const rowIdx = prodData.findIndex((r, i) => i > 0 && String(r[colCod]) === String(item.codigo));
      const novaQtd = Number(prodData[rowIdx][colQtd]) - item.qtd;
      sheetProd.getRange(rowIdx + 1, colQtd + 1).setValue(novaQtd);
      prodData[rowIdx][colQtd] = novaQtd;
    }

    const sheetVendas = getSheet(ABAS.VENDAS);
    const rowVenda = HEADERS.VENDAS.map(h => sanitize(venda[h] || ""));
    sheetVendas.appendRow(rowVenda);

    return { success: true };

  } catch (err) {
    Logger.log("[registrarVenda]", err);
    return { success: false, error: err.message };
  } finally {
    try { lock.releaseLock(); } catch (_) {}
  }
}

function getSaidasCaixa() {
  try {
    const sheet = getSheet(ABAS.SAIDAS_CAIXA);
    const data = sheetToObjects(sheet);
    return { success: true, data };
  } catch (err) {
    Logger.log("[getSaidasCaixa]", err);
    return { success: false, error: err.message };
  }
}

function addSaidaCaixa(saida) {
  if (!saida || !saida.valor || !saida.motivo)
    return { success: false, error: "Campos 'valor' e 'motivo' são obrigatórios." };

  try {
    const sheet = getSheet(ABAS.SAIDAS_CAIXA);
    const now = new Date();
    const row = [
      Utilities.formatDate(now, Session.getScriptTimeZone(), "dd/MM/yyyy"),
      Utilities.formatDate(now, Session.getScriptTimeZone(), "HH:mm:ss"),
      sanitize(saida.valor),
      sanitize(saida.motivo),
    ];
    sheet.appendRow(row);
    return { success: true };
  } catch (err) {
    Logger.log("[addSaidaCaixa]", err);
    return { success: false, error: err.message };
  }
}

function abrirCaixa(caixa) {
  if (!caixa || caixa.valorInicial === undefined || caixa.valorInicial === "")
    return { success: false, error: "Valor inicial é obrigatório." };

  try {
    const sheet = getSheet(ABAS.CAIXA);
    const now = new Date();
    const row = [
      Utilities.formatDate(now, Session.getScriptTimeZone(), "dd/MM/yyyy"),
      Utilities.formatDate(now, Session.getScriptTimeZone(), "HH:mm:ss"),
      sanitize(caixa.valorInicial),
      sanitize(caixa.usuario || "Não informado"),
    ];
    sheet.appendRow(row);
    return { success: true };
  } catch (err) {
    Logger.log("[abrirCaixa]", err);
    return { success: false, error: err.message };
  }
}

function getCaixaAberto() {
  try {
    const sheet = getSheet(ABAS.CAIXA);
    const data = sheetToObjects(sheet);
    const ultimo = data.length > 0 ? data[data.length - 1] : null;
    return { success: true, data: ultimo };
  } catch (err) {
    Logger.log("[getCaixaAberto]", err);
    return { success: false, error: err.message };
  }
}
