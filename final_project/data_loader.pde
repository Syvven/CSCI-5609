import java.io.BufferedReader;  
import java.io.FileReader;  
import java.io.IOException; 

public class WHOData
{
    private ArrayList<String[]> raw_data;
    private String file_path;
    public WHOData(String path)
    {
        this.load_raw_from_csv(path);
    }

    /* 
        Loads raw data from file path provided
        Assumes a comma seperated value file
    */
    private void load_raw_from_csv(String path)
    {
        this.file_path = path;
        raw_data = new ArrayList<String[]>();

        String line = "";
        try 
        {
            BufferedReader br = new BufferedReader(
                new FileReader(this.file_path)
            );
            while ((line = br.readLine()) != null)
            {
                raw_data.add(line.split(","));
            }
        } 
        catch (IOException e)
        {
            e.printStackTrace();
        }
        println(
            "Successfully loaded " + 
            raw_data.size() + 
            " lines of data from " + 
            this.file_path + "."
        );
    }

    /* getters */

    public ArrayList<String[]> getRawData() { return raw_data; }
    public String[] getFeatures() { return raw_data.get(0); }  


}