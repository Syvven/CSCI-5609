void setup()
{
    WHOData d = new WHOData(
        "D:\\Projects\\CSCI-5609\\final_project\\who_aap_2021_v9_11august2022_replaced.csv"
    );

    ArrayList<String[]> data = d.getRawData();
    println("\nPrinting first 20 entries:");
    println("Features:");
    for (int i = 0; i < data.get(0).length-1; i++)
    {
        print(data.get(0)[i] + ", ");
    }
    println(data.get(0)[data.get(0).length-1]);

    println("\nData:");
    for (int i = 0; i < 20; i++)
    {
        for (int j = 0; j < data.get(i).length-1; j++)
        {
            print(data.get(i)[j] + ", ");
        }
        println(data.get(i)[data.get(i).length-1]);
    }
}