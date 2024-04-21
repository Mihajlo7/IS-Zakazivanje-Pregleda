using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.DTOs
{
    public class InsPregledDTO
    {
        public string Jmbg {  get; set; }
        public string ImeDoktora { get; set; }
        public string PrezimeDoktora { get; set; }
        public string DatumPregleda { get; set; }
        public string VremePregleda { get; set; }
    }
}
