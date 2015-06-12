import L3D.*;

L3D cube;

JSONArray json;
JSONObject station;
int stationId;
JSONArray stationData;
JSONArray stationPoints;
JSONArray stationPointVoxel;
JSONArray stationPointColor;

int currStation = 0;
int currTimeseries = 0;
int currPoint = 0;

int maxStation = 8;
int maxTimeseries = 8;
int maxPoints = 8;

void setup()
{
  size(displayWidth, displayHeight, P3D);
  cube = new L3D(this, "", "", 8);

  json = loadJSONArray("data.json");
  /*
  // Loop through stations.
  for (int i = 0; i < json.size(); i++) {
    station = json.getJSONObject(i); 

    stationId = station.getInt("station");
    stationData = station.getJSONArray("data");
    
    // Loop through timeseries.
    for (int t = 0; t < stationData.size(); t++) {
      stationPoints = stationData.getJSONArray(t);
      
      // Loop through points.
      for (int p = 0; p < stationPoints.size(); p++) {
        stationPointVoxel = stationPoints.getJSONObject(p).getJSONArray("point");
        stationPointColor = stationPoints.getJSONObject(p).getJSONArray("color");
        println( "Station: " + stationId + " " + stationPointVoxel + " " + stationPointColor );
        cube.setVoxel( stationPointVoxel.getInt(0), stationPointVoxel.getInt(1), stationPointVoxel.getInt(2), color(stationPointColor.getInt(0), stationPointColor.getInt(1), stationPointColor.getInt(2)) );
      }
    }
  }*/
}

JSONObject _drawStation(int id, int series, int point)
{
  JSONObject returnVal = new JSONObject();
  // Loop through stations.
  for (int i = 0; i < json.size(); i++) {
    station = json.getJSONObject(i);
    stationId = station.getInt("station");
    if (stationId == id) {
      stationData = station.getJSONArray("data");
      // Loop through timeseries.
      for (int t = 0; t < stationData.size(); t++) {
        if (t == series) {
          stationPoints = stationData.getJSONArray(t);
          // Loop through points.
          for (int p = 0; p < stationPoints.size(); p++) {
            if ( p == point ) {
              returnVal = stationPoints.getJSONObject(p);
              break;
            }
          }
          break;
        }
      }
      break;
    }
  }
  return returnVal;
}

void draw()
{
  background(0);
  
  if (frameCount%20 == 0) {      
    for (int s = 0; s < maxStation; s++) {
      for (int p = 0; p < maxPoints; p++) {
        JSONObject currData = _drawStation(s, currTimeseries, p);
        stationPointVoxel = currData.getJSONArray("point");
        stationPointColor = currData.getJSONArray("color");
        //println( "Station: " + stationId + " " + stationPointVoxel + " " + stationPointColor );
        cube.setVoxel( stationPointVoxel.getInt(0), 7-stationPointVoxel.getInt(1), stationPointVoxel.getInt(2), 
                       color(stationPointColor.getInt(0), stationPointColor.getInt(1), stationPointColor.getInt(2)) );
      }
    }

    if (++currTimeseries > maxTimeseries-1) {
      currTimeseries = 0;
    }
  }
}

