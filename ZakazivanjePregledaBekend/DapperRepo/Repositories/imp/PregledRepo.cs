using Dapper;
using Models.DTOs;
using Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DapperRepo.Repositories.imp
{
    public class PregledRepo : IPregledRepo
    {
        private readonly DapperContext _dapperContext;

        public PregledRepo(DapperContext dapperContext)
        {
            _dapperContext = dapperContext; 
        }

        public async Task<IEnumerable<Osoba>> getGojazneOsobe()
        {
            var query ="SELECT * FROM dbo.viewGojazneOsobe";
            using(var connection=_dapperContext.CreateConnection())
            {
                var result= await connection.QueryAsync<Osoba>(query);
                _dapperContext.CloseConnection(connection);
                return result.ToList();
            }
        }

        public async Task<OsobaDTO> GetPregledePoJmbg(string jmbg)
        {
            var query = "SELECT * FROM dbo.fnVratiSvePregledePoJmbg(@jmbg)";
            using(var connection = _dapperContext.CreateConnection())
            {
                var osobe = await connection.QueryAsync<OsobaDTO, PregledDTO, OsobaDTO>(query,map:
                    (osoba, pregled) =>
                    {
                        //osoba.Pregledi=new List<PregledDTO>();
                        osoba.Pregledi.Add(pregled);
                        return osoba;
                    }, splitOn: "PregledId",
                    param: new { jmbg});
                _dapperContext.CloseConnection(connection);

                var osoba = osobe.GroupBy(o => o.OsobaId).Select(g =>
                {
                    var grupa = g.First();
                    grupa.Pregledi = g.Select(o => o.Pregledi.Single()).ToList();
                    return grupa;
                });

                return osoba.First();
            };
        }

        public Task<bool> TestConnection()
        {
            using var connection =_dapperContext.CreateConnection();
            return Task.FromResult(true);
        }
    }
}
