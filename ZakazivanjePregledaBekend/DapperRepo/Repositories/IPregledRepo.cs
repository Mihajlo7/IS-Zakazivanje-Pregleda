using Models.DTOs;
using Models.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DapperRepo.Repositories
{
    public interface IPregledRepo
    {
        Task<bool> TestConnection();
        Task<IEnumerable<Osoba>> getGojazneOsobe();
        Task<OsobaDTO> GetPregledePoJmbg(string jmbg);
        Task<MaxVisinaDTO> GetMaxVisina();
        Task<IEnumerable<OsobaDTO>> GetUrgentnePreglede();
        Task<ResponseDTO> InsertPregled(InsPregledDTO pregledDTO);
        Task<ResponseDTO> UpdatePregled(PregledDTO pregledDTO,string jmbg);
        Task<ResponseDTO> DeletePregled(DelPregled delPregled);
    }
}
