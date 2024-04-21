using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;

namespace DapperRepo
{
    public class DapperContext
    {
        private readonly IConfiguration _configuration;
        private readonly string _connectionString;

        public DapperContext(IConfiguration configuration)
        {
            _configuration = configuration;
            _connectionString = _configuration.GetConnectionString("connection");
        }

        public IDbConnection CreateConnection() =>
            new SqlConnection(_connectionString);

        public void CloseConnection(IDbConnection connection)
        {
            if(connection.State == ConnectionState.Open || connection.State==ConnectionState.Broken)
            {
                connection.Close();
            }
        }
       
    }
}