using Microsoft.EntityFrameworkCore;

namespace ThaissaLeslye.PlataformaQA.Infraestrutura.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
        }

        // Futuramente, as tabelas estarão aqui:
        // public DbSet<Projeto> Projetos { get; set; }
    }
}