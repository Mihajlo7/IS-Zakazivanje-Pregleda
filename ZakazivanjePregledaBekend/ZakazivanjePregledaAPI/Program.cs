using Microsoft.AspNetCore.HttpOverrides;
using NLog;
using ZakazivanjePregledaAPI.Extensions;

namespace ZakazivanjePregledaAPI
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            LogManager.Setup().LoadConfiguration(config =>
            {
               
            });
            builder.Services.ConfigureDapper();
            builder.Services.ConfigurePregledRepo();
            builder.Services.ConfigureCORS();
            builder.Services.ConfigureIISIntegration();
            builder.Services.ConfigureLoggerService();
            builder.Services.AddControllers();

            var app = builder.Build();

            // Configure the HTTP request pipeline.

            if(app.Environment.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseStaticFiles();


            app.UseForwardedHeaders(new ForwardedHeadersOptions
            {
                ForwardedHeaders = ForwardedHeaders.All
            });
            app.UseCors("ZakazivanjePregledaCORS");
            app.UseAuthorization();


            app.MapControllers();

            app.Run();
        }
    }
}