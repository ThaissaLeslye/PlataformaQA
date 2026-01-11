
using ThaissaLeslye.PlataformaQA.Infraestrutura.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// ==========================s2=========================
// 1. Configuração de Serviços (Dependency Injection)
// ==========================s2=========================

// s2 Configuração do Banco de Dados (MySQL)
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseMySql(connectionString, ServerVersion.AutoDetect(connectionString)));

// s2 Adiciona suporte a Controllers (API tradicional)
builder.Services.AddControllers();

// s2 Configuração do Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Plataforma QA API",
        Version = "v1"
    });
});

var app = builder.Build();

// ====================s2======================
// 2. Configuração do Pipeline (Middleware)
// ====================s2======================

// s2 Ativa o Swagger apenas em desenvolvimento
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

// s2 Mapeia os Controllers
app.MapControllers();

app.Run();
