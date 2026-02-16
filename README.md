# Plataforma QA

## 📋 Pré-requisitos

Certifique-se de ter as seguintes ferramentas instaladas nas versões compatíveis:

* **.NET SDK:** [9.0.306]
* **Node.js:** [22.19.0]
* **Angular CLI:** [21.0.5]
* **Node:** [22.19.0]

## ⚙️ Configuração do Ambiente

Como os arquivos de configuração sensíveis não estão no repositório, siga estes comandos para recriar o ambiente local:

### Backend

```bash
cd src/ThaissaLeslye.PlataformaQA.API
dotnet user-secrets init
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Server=localhost;Database=<BANCO>;User=<USER>;Password=<SUA_SENHA>;"
```

### Frontend

```bash 
```

## 🚀 Como Rodar

### Backend (.NET)

```bash
cd src/ThaissaLeslye.PlataformaQA.API
dotnet restore
dotnet run
```

### Frontend (Angular)

```bash
ng serve
```
