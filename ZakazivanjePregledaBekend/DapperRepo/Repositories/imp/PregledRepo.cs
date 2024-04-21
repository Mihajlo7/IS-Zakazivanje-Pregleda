using Dapper;
using Models.DTOs;
using Models.Entities;
using System;
using System.Collections.Generic;
using System.Data;
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

        public async Task<ResponseDTO> DeletePregled(DelPregled delPregled)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("jmbg", delPregled.Jmbg);
            parameters.Add("PregledId",delPregled.PregledId);

            using(var connection= _dapperContext.CreateConnection())
            {
                var result = await connection.ExecuteAsync("dbo.insPregled",
                    parameters, commandType: System.Data.CommandType.StoredProcedure);
                _dapperContext.CloseConnection(connection);

                return new ResponseDTO
                {
                    Message = "Uspesno je azuriran pregled sa id " + delPregled.PregledId + " ."
                };
            }
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

        public async Task<MaxVisinaDTO> GetMaxVisina()
        {
            var query="SELECT dbo.fnMaxVisina() MaxVisina";

            using(var connection = _dapperContext.CreateConnection())
            {
                var result=await connection.QueryAsync<MaxVisinaDTO>(query);
                _dapperContext.CloseConnection(connection);
                return result.First();
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

        public async Task<IEnumerable<OsobaDTO>> GetUrgentnePreglede()
        {
            var query = "SELECT * FROM dbo.fnUrgentniPregledi()";

            using(var connection= _dapperContext.CreateConnection())
            {
                var osobe = await connection.QueryAsync<OsobaDTO, PregledDTO, OsobaDTO>(query, map:
                    (osoba, pregled) =>
                    {
                        osoba.Pregledi.Add(pregled);
                        return osoba;
                    },splitOn:"PregledId");

                _dapperContext.CloseConnection(connection );

                var result = osobe.GroupBy(osoba => osoba.OsobaId).Select(grupa =>
                {
                    var grupisaneOsobe = grupa.First();
                    grupisaneOsobe.Pregledi = grupa.Select(osoba => osoba.Pregledi.Single()).ToList();
                    return grupisaneOsobe;
                });

                return result;
            }
        }

        public async Task<ResponseDTO> InsertPregled(InsPregledDTO pregledDTO)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("jmbg", pregledDTO.Jmbg);
            parameters.Add("ImeDoktora", pregledDTO.ImeDoktora);
            parameters.Add("PrezimeDoktora", pregledDTO.PrezimeDoktora);
            parameters.Add("DatumPregleda", pregledDTO.DatumPregleda);
            parameters.Add("VremePregleda", pregledDTO.VremePregleda);

            using(var connection = _dapperContext.CreateConnection())
            {
                var result = await connection.ExecuteAsync("dbo.insPregled",
                    parameters, commandType: System.Data.CommandType.StoredProcedure);
                _dapperContext.CloseConnection(connection);

                return new ResponseDTO
                {
                    Message="Uspesno je kreiran pregled za osobu sa jmbg "+pregledDTO.Jmbg+" ."
                };

            }
        }

        public Task<bool> TestConnection()
        {
            using var connection =_dapperContext.CreateConnection();
            return Task.FromResult(true);
        }

        public async Task<ResponseDTO> UpdatePregled(PregledDTO pregledDTO, string jmbg)
        {
            DynamicParameters parameters = new DynamicParameters();
            parameters.Add("jmbg", jmbg);
            parameters.Add("PregledId", pregledDTO.PregledId);
            parameters.Add("ImeDoktora", pregledDTO.ImeDoktora);
            parameters.Add("PrezimeDoktora", pregledDTO.PrezimeDoktora);
            parameters.Add("DatumPregleda", pregledDTO.DatumPregleda);
            parameters.Add("VremePregleda", pregledDTO.VremePregleda);

            using(var connection = _dapperContext.CreateConnection())
            {
                var result =
                   await connection.ExecuteAsync("dbo.updPregled",parameters, commandType: System.Data.CommandType.StoredProcedure);

                _dapperContext.CloseConnection(connection);

                return new ResponseDTO
                {
                    Message = "Uspesno je azuriran pregled sa id " + pregledDTO.PregledId + " ."
                };
            }
        }
    }
}
