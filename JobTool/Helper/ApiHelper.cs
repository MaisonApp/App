using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using MAISONApp.Entity;
using Newtonsoft.Json.Linq;

using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Dynamic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;
//using System.Web.Script.Serialization;

namespace MAISONApp.Helper
{
    public static class ApiHelper
    {
        public static async Task ConnectToAPI()
        {
            try
            {
                using (HttpClient client = new HttpClient())
                {

                    ResultData routingNumber = null;
                    JObject data = null;
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "pvhrOvmnYVKlcUb14g35qq0jaYFFHP3WNLVb8IXOf-E");
                    HttpResponseMessage response =
                        await client.GetAsync("https://apis.haravan.com/com/products.json");
                    if (response.IsSuccessStatusCode)
                    {
                        //dynamic data = serializer.Deserialize(json, typeof(object));
                        //routingNumber = await response.Content.ReadAsAsync<ResultData>();
                        //data = await response.Content.ReadAsAsync<JObject>();
                        String test = await response.Content.ReadAsStringAsync();
                    }
                    foreach (JToken item in data.Children())
                    {
                        //String test = item.Value<string?>("products")?? "";
                        //JObject temp = JObject.Parse(item.Value<string>("products"));
                        //Console.WriteLine("temp " + test.ToString());


                        //var myElement = item.FirstOrDefault(x => x.Name == "products");
                        //var itemProperties = item.Children<JProperty>();
                        //Console.WriteLine("value "+ itemProperties);
                        //If the property name is equal to key, we get the value
                        //var myElement = itemProperties.FirstOrDefault(x => x.Name == "products");
                        //String value = myElement.Value.ToString(); //It run into an exception here because myElement is null
                        //Console.WriteLine("value "+ value);
                    }
                    //foreach (var item in routingNumber.Products)
                    //{
                    //    Console.WriteLine("Product: " + item.Title);
                    //}

                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception " + ex.ToString());
            }
        }

        public static async Task APIGetUpdatedProduct()
        {
            try
            {
                using (HttpClient client = new HttpClient())
                {
                    JArray results = new JArray();
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", "pvhrOvmnYVKlcUb14g35qq0jaYFFHP3WNLVb8IXOf-E");
                    int countResult = 0;
                    int page = 1;
                    String currentDate = DateTime.Now.ToString("yyyy-MM-dd 00:00");
                    String content = "";
                    do
                    {
                        JObject data = null;
                        String url = "https://apis.haravan.com/com/products.json?limit=50&fields=variants&page=" + page + "&updated_at_min=" + currentDate + "";
                        HttpResponseMessage response =
                        await client.GetAsync(url);
                        if (response.IsSuccessStatusCode)
                        {
                            data = await response.Content.ReadAsAsync<JObject>();
                            JArray temp = data.Value<JArray>("products");
                            foreach (JToken item in temp)
                            {
                                JArray temp1 = item.Value<JArray>("variants");
                                foreach (JToken item1 in temp1)
                                {
                                    results.Add(item1);
                                }
                            }


                            //content = data.Value<String>("products");
                            //Console.WriteLine("temp " + temp1.Count());
                            //content = await response.Content.ReadAsStringAsync();
                            countResult = temp.Count;
                        }
                        else
                        {
                            countResult = 0;
                        }
                        Console.WriteLine("count " + countResult + " " + page);
                        page++;
                    } while (countResult > 49);
                    Console.WriteLine("results " + results.Count);
                    await File.WriteAllTextAsync("WriteText.txt", results.ToString());
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception " + ex.ToString());
            }
        }

        public static async Task APIGetUpdatedProduct2(string url, string typeAuth, string token)
        {
            try
            {
                Console.WriteLine($"Now " + DateTime.Now);
                using (HttpClient client = new HttpClient())
                {
                    JArray results = new JArray();
                    client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(typeAuth, token);
                    DataSet ds = Utility.ExecuteDataSet("IMEX_ProductToCheck_GetList");
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0] != null)
                    {
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            JObject data = null;
                            string ProductBarcode = Convert.ToString(dr["ProductID"].ToString());
                            url = url + "?fields=variants&barcode" + ProductBarcode + "";
                            HttpResponseMessage response =
                            await client.GetAsync(url);
                            if (response.IsSuccessStatusCode)
                            {
                                data = await response.Content.ReadAsAsync<JObject>();
                                JArray temp = data.Value<JArray>("products");
                                foreach (JToken item in temp)
                                {
                                    JArray temp1 = item.Value<JArray>("variants");
                                    foreach (JToken item1 in temp1)
                                    {
                                        String test = item1.Value<string>("barcode");
                                        if (!results.Any(x => x.Value<string>("barcode") == test))
                                        {
                                            results.Add(item1);
                                        }
                                    }
                                }
                            }
                        }
                        Console.WriteLine($"Now " + DateTime.Now);
                        Console.WriteLine($"Total result: {results.Count}");
                    }
                    await File.WriteAllTextAsync("E:\\WriteText.json", results.ToString());
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Exception " + ex.ToString());
            }
        }
    }
}
