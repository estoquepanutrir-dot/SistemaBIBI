# BIBI PAPELARIA - Backend Google Apps Script

## Estrutura da Planilha

Crie uma planilha no Google Sheets com as seguintes abas (nomes exatos):

### 1. Produtos
| nome | codigo | categoria | preco | quantidade | fornecedor |
|------|--------|-----------|-------|------------|------------|

### 2. Vendas
| data | hora | itens | subtotal | desconto | total | pagamento |
|------|------|-------|----------|----------|-------|-----------|

### 3. SaidasCaixa (NOVO)
| data | hora | valor | motivo |
|------|------|-------|--------|

### 4. Caixa (NOVO)
| data | hora | valorInicial | usuario |
|------|------|--------------|---------|

## Deploy do Google Apps Script

1. Acesse [script.google.com](https://script.google.com)
2. Crie um novo projeto
3. Cole o conteúdo do arquivo `codigo_apps_script.gs`
4. Substitua `SEU_SPREADSHEET_ID_AQUI` pelo ID da sua planilha (encontrado na URL)
5. Clique em **Implantar** > **Nova Implantação**
6. Configure:
   - Tipo: App da Web
   - Executar como: **Eu**
   - Quem pode acessar: **Qualquer pessoa**
7. Copie a URL gerada e cole em `API_URL` no arquivo `index.html`

## API Actions

### Produtos
- `getProdutos` - Lista todos os produtos
- `addProduto` - Adiciona novo produto
- `updateProduto` - Atualiza produto existente
- `deleteProduto` - Remove produto por código

### Vendas
- `getVendas` - Lista todas as vendas
- `registrarVenda` - Registra venda e deduz estoque automaticamente

### Caixa (NOVO)
- `abrirCaixa` - Registra abertura de caixa com valor inicial
- `getCaixaAberto` - Retorna último registro de abertura de caixa

### Saídas de Caixa (NOVO)
- `addSaidaCaixa` - Registra saída de caixa (valor + motivo)
- `getSaidasCaixa` - Lista todas as saídas de caixa

## Exemplo de Requisição

```javascript
fetch(API_URL, {
  method: "POST",
  body: JSON.stringify({
    action: "addSaidaCaixa",
    saida: {
      valor: 50.00,
      motivo: "Pagamento fornecedor"
    }
  })
});
```
