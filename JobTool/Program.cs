using System;
using System.Configuration;

namespace MAISONApp
{
    public static class Program
    {

        private static void Main(string[] args)
        {
            try
            {
                int CmdTimeout = Convert.ToInt32(ConfigurationManager.AppSettings["CmdTimeout"]);
                if (args == null || args.Length == 0)
                {
                    Console.Write("Enter Job: ");
                    args = new string[10];
                    args[0] = Console.ReadLine().ToString();
                }
                if (args != null && args.Length > 0)
                {
                    int job = Convert.ToInt32(args[0]);
                    new ThreadJob(job, CmdTimeout, 1);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }

        }

       
    }
}