using System.Diagnostics;
using Microsoft.AspNetCore.Mvc.RazorPages;

public class ToolsModel : PageModel
{
    public string message { get; private set; } = "";

    // Multi purpose controller method, 
    // Couldn't find a way to do this with routes/annotations in Razor Pages
    public void OnGet(string action, int value)
    {
        // Run the garbage collector
        if (action == "gc")
        {
            System.GC.Collect();
            message = "Garbage collection was run";
        }

        // Try to allocate some memory
        if (action == "alloc")
        {
            int MB_SIZE = 50;
            if (value > 0)
            {
                MB_SIZE = value;
            }

            try
            {
                double[] stringArray = new double[MB_SIZE * 1024 * 1000];
                message = "Allocated array with space for " + (MB_SIZE * 1024 * 1000) + " doubles";
            }
            catch (Exception ex)
            {
                message = "Failed " + ex.ToString();
            }
        }

        // Just throw an exception
        if (action == "exception")
        {
            throw new System.InvalidOperationException("Cheese not found");
        }

        // Force some CPU load in a loop
        if (action == "load")
        {
            double time;
            long loops;
            const double pow_base = 9000000000;
            const double pow_exponent = 9000000000;
            const int default_loops = 20;

            Stopwatch sw = new System.Diagnostics.Stopwatch();
            sw.Start();
            loops = default_loops;
            if (value > 0) loops = value;

            double res;
            for (var i = 0; i <= loops * 1000000; i++)
            {
                res = Math.Pow(pow_base, pow_exponent);
            }

            time = sw.ElapsedMilliseconds / 1000.0;
            message = $"I calculated a really big number {loops} million times! It took {time} seconds!";
        }
    }
}