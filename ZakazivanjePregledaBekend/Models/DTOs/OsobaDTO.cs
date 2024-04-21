using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.DTOs
{
    public class OsobaDTO
    {
        public Guid OsobaId {  get; set; }
        public string Ime { get; set; }
        public string Prezime { get; set; }
        public decimal Visina { get; set; }
        public decimal Tezina { get; set; }
        public decimal Bmi { get; set; }
        public List<PregledDTO> Pregledi { get; set; }= new List<PregledDTO>();
    }
}
