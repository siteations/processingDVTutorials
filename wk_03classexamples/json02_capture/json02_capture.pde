JSONArray trash;
JSONArray capture;

void setup() {
  size(1000, 500);
  background(255);

  trash = loadJSONArray("http://data.cityofnewyork.us/resource/ewtv-wftx.json");
  capture = loadJSONArray("http://data.cityofnewyork.us/resource/gaq9-z3hz.json");

  for (int i = 1; i < trash.size(); i++) {

    JSONObject item = trash.getJSONObject(i); 
    JSONObject recv = capture.getJSONObject(i);

    float paper = item.getFloat("papertonscollected");
    float mpg = item.getFloat("mgptonscollected");
    float refuse = item.getFloat("refusetonscollected");
    String boro = item.getString("borough");
    String comDis = item.getString("communitydistrict");
    
    float paperR = recv.getFloat("capture_rate_paper_total_paper_max_paper_");
    float mpgR = recv.getFloat("capture_rate_mgp_total_mgp_max_mgp_");
    String district = recv.getString("district");

    //add onto existing table and save for static use
    item.setString("district", district);
    item.setString("paper_capture", str(paperR));
    item.setString("mpg_capture", str(mpgR));

    //println("For " + boro + ", community district "+comDis +":");
    fill(0, 100);
    noStroke();
    fill(255, 0, 0, 100);
    rect(25, 8*i, paper/10, 4);
    fill(0, 255, 0, 100);
    rect(25+paper/10, 8*i, mpg/10, 4);
    fill(0, 0, 255, 100);
    rect(25+paper/10+mpg/10, 8*i, refuse/10, 4);
  }
}

