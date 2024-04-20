using Contracts;
using LoggerService;
using System.Runtime.CompilerServices;

namespace ZakazivanjePregledaAPI.Extensions
{
    public static class ServiceExtensions
    {
        public static void ConfigureCORS(this IServiceCollection services)
        {
            services.AddCors(options =>
            {
                options.AddPolicy("ZakazivanjePregledaCORS", builder =>
                builder.AllowAnyOrigin()
                .AllowAnyMethod()
                .AllowAnyHeader());
            });
        }

        public static void ConfigureIISIntegration(this IServiceCollection services)
        {
            services.Configure<IISOptions>(options => { });
        }

        public static void ConfigureLoggerService(this IServiceCollection services)=>
            services.AddSingleton<ILoggerManager, LoggerManager>();
    }
}
