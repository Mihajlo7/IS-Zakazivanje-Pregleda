using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Models.Entities
{
    public class Osoba
    {
        public Guid OsobaId { get; set; }
        public string Jmbg { get; set; }
        public string Ime { get; set; }
        public string Prezime { get; set; }
        public decimal Visina { get; set; }
        public decimal Tezina { get; set; }
        public decimal Bmi { get; set; }
        public virtual ICollection<Pregled> Pregledi { get; set; }= new List<Pregled>();
    }
}
