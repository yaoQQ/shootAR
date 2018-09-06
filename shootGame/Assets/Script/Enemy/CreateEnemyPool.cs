using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateEnemyPool : MonoBehaviour
{
    public int currWave = 0;
    public int totalWave = 3;
    public static int totalEnemyNum = 10;

    public CreateEnemyWave enemyWave;
    // Use this for initialization
    void Start()
    {

        createWave(currWave);
    }

    // Update is called once per frame
    void Update()
    {
       


    }
    public void createWave(int wave)
    {
       GameObject obj= MyUtils.LoadEffectPrefab("enemyWave/Wave" + wave);
        if (obj != null)
        {
            obj.transform.parent = this.transform;
            enemyWave = obj.GetComponent<CreateEnemyWave>();
            enemyWave.EndCallBackFun = EndWaveCallBakc;
        }
    }

    public void EndWaveCallBakc()
    {
        currWave++;
        if(currWave>= totalWave)//关卡结束
        {
           int wave= UnityEngine.Random.Range(0, totalWave);
            createWave(wave);
            return;
        }
        createWave(currWave);
    }
   
}