using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace Models.DTOs
{
    public class PregledDTO
    {
        public long PregledId { get; set; }
        public string ImeDoktora { get; set; }
        public string PrezimeDoktora { get; set; }
        public DateTime DatumPregleda { get; set; }
        public string VremePregleda { get; set; }
    }
}
