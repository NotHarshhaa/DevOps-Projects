using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Graph;

namespace DotnetDemoapp.Pages
{
    [Authorize]
    public class UserInfoModel : PageModel
    {
        private readonly ILogger<UserInfoModel> _logger;
        private readonly GraphServiceClient _graphServiceClient;

        public string username { get; private set; } = "";
        public string oid { get; private set; } = "";
        public string name { get; private set; } = "";
        public string tenantId { get; private set; } = "";
        public string preferredUsername { get; private set; } = "";
        public Dictionary<string, string> graphData = new Dictionary<string, string>();
        public byte[] graphPhoto;

        public UserInfoModel(ILogger<UserInfoModel> logger, GraphServiceClient graphServiceClient)
        {
            _logger = logger;
            _graphServiceClient = graphServiceClient;
        }

        public async Task<IActionResult> OnGet()
        {
            foreach (Claim claim in User.Claims)
            {
                if (claim.Type.Contains("objectidentifier") || claim.Type.Contains("oid"))
                {
                    oid = claim.Value;
                }
                if (claim.Type.Contains("tenant") || claim.Type.Contains("tid"))
                {
                    tenantId = claim.Value;
                }
                if (claim.Type == "name")
                {
                    name = claim.Value;
                }
                if (claim.Type == "preferred_username")
                {
                    preferredUsername = claim.Value;
                }
            }

            username = User.Identity.Name;

            // Graph stuff
            // Acquire the access token
            try
            {
                // Fetch user details from Graph API
                var graphDetails = await _graphServiceClient.Me
                .Request()
                .GetAsync();

                graphData.Add("UPN", graphDetails.UserPrincipalName);
                graphData.Add("Given Name", graphDetails.GivenName);
                graphData.Add("Display Name", graphDetails.DisplayName);
                graphData.Add("Office", graphDetails.OfficeLocation);
                graphData.Add("Mobile", graphDetails.MobilePhone);
                graphData.Add("Other Phone", graphDetails.BusinessPhones.Count() > 0 ? graphDetails.BusinessPhones.First() : "");
                graphData.Add("Job Title", graphDetails.JobTitle);

                // Fetch user photo, this used to fail with MSA accounts hence the extra try/catch
                try
                {
                    Stream pictureStream = await _graphServiceClient
                    .Me
                    .Photos["432x432"]
                    .Content
                    .Request()
                    .GetAsync();

                    // Convert to bytes
                    graphPhoto = ToByteArray(pictureStream);
                }
                catch (Exception e)
                {
                    _logger.LogWarning(e.ToString());
                }
            }
            catch (Exception)
            {
                // Cookie seems to get out of sync with the token cache when hotreloading the page
                // This is a horrible hack
                foreach (var cookie in Request.Cookies.Keys)
                {
                    Response.Cookies.Delete(cookie);
                }
                return Redirect("/");
            }
            return Page();
        }

        private Byte[] ToByteArray(Stream stream)
        {
            Int32 length = stream.Length > Int32.MaxValue ? Int32.MaxValue : Convert.ToInt32(stream.Length);
            Byte[] buffer = new Byte[length];
            stream.Read(buffer, 0, length);
            return buffer;
        }
    }
}
