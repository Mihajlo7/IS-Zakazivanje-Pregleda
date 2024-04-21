﻿using DapperRepo.Repositories;
using Microsoft.AspNetCore.Mvc;

namespace ZakazivanjePregledaAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PreglediController: ControllerBase
    {
        private readonly IPregledRepo _pregledRepo;

        public PreglediController(IPregledRepo pregledRepo)
        {
            _pregledRepo = pregledRepo;
        }

        [HttpGet]
        public async Task<IActionResult> Test()
        {
            return Ok(await _pregledRepo.TestConnection());
        }

        [HttpGet("gojazneOsobe")]
        public async Task<IActionResult> GetGojazneOsobe()
        {
            return Ok(await _pregledRepo.getGojazneOsobe());
        }

        [HttpGet("{jmbg}")]
        public async Task<IActionResult> GetPreglediPoJmbg(string jmbg)
        {
            return Ok(await _pregledRepo.GetPregledePoJmbg(jmbg));
        }
        [HttpGet ("maxVisina")]
        public async Task<IActionResult> GetMaxVisina()
        {
            return Ok(await _pregledRepo.GetMaxVisina());
        }
        [HttpGet("urgentniPregledi")]
        public async Task<IActionResult> GetUrgentnePreglede()
        {
            return Ok(await _pregledRepo.GetUrgentnePreglede());
        }
    }
}
