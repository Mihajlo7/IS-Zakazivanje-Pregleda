using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.Entities
{
    public class Pregled
    {
        public Osoba Osoba {  get; set; }
        public long PregledId { get; set; }
        public string ImeDoktora { get; set; }
        public string PrezimeDoktora { get; set; }
        public DateTime DatumPregleda { get; set; }
        public TimeSpan VremePregleda { get; set; }
    }
}
