using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Net.Http;



namespace bd
{
   
    public partial class Form1 : Form
    { 
        private static readonly HttpClient client = new HttpClient();
        Dictionary<string,string> values = new Dictionary<string, string>();
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private async void button1_Click(object sender, EventArgs e)
        {
            values = new Dictionary<string, string>();
            //sending the sql command that was written in the texbox to the api and waiting for a response
            values.Add("data", richTextBox1.Text);
            var content = new FormUrlEncodedContent(values);
            var response = await client.PostAsync("http://localhost/sql/ciau.php", content);
            var responseString = await response.Content.ReadAsStringAsync();
            ///
            
            //Parsing the response data 
            DataTable a = new DataTable();
            if (responseString == "0 results")
            {
                MessageBox.Show("0 rezultate");
                return;
            }
            var res = responseString.Split('\n');
            for (int i = 0; i < res[0].Split(' ').Length-1; i++)
                a.Columns.Add(i.ToString());

            DataRow[] rows = new DataRow[res.Length-1];
            for(int i=0;i<res.Length-1;i++)
            {
                rows[i] = a.NewRow();
            }
            int j = 0;
            foreach(string x in res)
            {
                var abc= x.Split(' '); 
                for (int i = 0; i < abc.Length-1; i++)
                    rows[j][i.ToString()] = abc[i];
                j++;
            }
            foreach(var ag in rows)
            a.Rows.Add(ag);
            dataGridView1.DataSource = a;
            
            
            
        }

        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {

        }
    }
}
