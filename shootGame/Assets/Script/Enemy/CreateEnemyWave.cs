using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public struct EnemyWave
{

    public int totalCreateEnemy;
    public List<EnemyLevel> enemyLevel;
}

[Serializable]
public struct EnemyLevel
{
    [Header("敌人出现时间")]
    public float showTime;
    [Header("敌人列表")]
    public List<GameObject> enemyList;
}
public class CreateEnemyWave : MonoBehaviour
{
    public int curentWave = 0;
    [Header("延迟等待波数时间")]
    public float delayTime = 0;
    public int totalCreateNum = 15;

    [Header("EnemyLevel配置当前关卡敌方批数")]
    public List<EnemyLevel> enemyWaveList = new List<EnemyLevel>(1);

    public float time;
    public int currLevel=0;

    private float randomPos = 0.6f;
    private bool isInit = false;

    public delegate void EndCallBackDelegate();
    public EndCallBackDelegate EndCallBackFun;
    // Use this for initialization
    void Start()
    {

    }

    private void showWaveEnemy()
    {
        if(MonsterManager.Instance.currEnemyCount>= CreateEnemyPool.totalEnemyNum)
        {
            return;
        }

        if (!isInit)
        {
            time = enemyWaveList[0].showTime;
            isInit = true;
            return;
        }
        List<GameObject> enemyList = enemyWaveList[0].enemyList;
        for (int i = 0; i < enemyList.Count; i++)
        {
            if (enemyList[i] == null)
                continue;
            MonsterManager.Instance.createrDoolMonster(enemyList[i]);
        }
        enemyWaveList.RemoveAt(0);
        currLevel++;
        isInit = false;
        if (enemyWaveList.Count==0)
        {
            if (EndCallBackFun != null)
            {
                EndCallBackFun();
            }
            GameObject.Destroy(this.gameObject);
        }
    }


    public void Update()
    {
        delayTime -= Time.deltaTime;
        if (delayTime > 0)
            return;
        time -= Time.deltaTime;
        if (time > 0)
            return;
        showWaveEnemy();
    }
    private Vector3 RandomBorePos()
    {

        Vector3 initPos = this.transform.position;
        float z = initPos.z;
        float x = initPos.x;
        float y = CameraManager.Instance.Player.position.y + UnityEngine.Random.Range(0, 1); ;
        z = initPos.z + UnityEngine.Random.Range(0, 0.6f);
        x = initPos.x + UnityEngine.Random.Range(0, randomPos);


        return new Vector3(x, y, z);
    }
}