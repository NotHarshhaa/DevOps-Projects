using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace aspnet_core_dotnet_core.Pages
{
    public class IndexModel : PageModel
    {
        public void OnGet()
        {

        }
        public string DoTest()
        {
            return "Index";
        }
    }
}