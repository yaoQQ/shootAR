using System;
using System.Collections.Generic;
using LITJson;

public class LevelData
{
    public float intervalTime = 0;
    public List<int> enemys = null;

    public bool isUsed = false;

    public LevelData(string jsonStr)
    {
        JsonData jsonData = JsonMapper.ToObject(jsonStr);
        this.intervalTime = (int)jsonData["intervalTime"];

        enemys = new List<int>();
        JsonData enemysData = jsonData["enemy"];
        for (int i = 0; i < enemysData.Count; i++)
        {
            enemys.Add((int)enemysData[i]);
        }
    }

}

