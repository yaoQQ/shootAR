using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class MonsterManager : Singleton<MonsterManager>
{

    private List<Enemy> monsterList = new List<Enemy>();
    private int addCount = 0;
    private Map _map;
    public static int totalEnemy;
    public GameObject boss;
    public int currEnemyCount
    {
        get
        {
            return monsterList.Count;
        }
    }

    //直接产生敌方
    public GameObject createrMonster(GameObject MonsterClone, Vector3 borePos, Vector3 targetPos)
    {
        if (MonsterClone == null)
        {
            return null;
        }

        addCount++;
        GameObject monster = ResourceManagerPool.Instance.GetPoolObject(MonsterClone.name, ResourceType.ship);
        Enemy enemy = monster.GetComponent<Enemy>();
         monster.transform.position = borePos;
        enemy.targetPos = targetPos;
        monster.name = monster.name + addCount;
        monsterList.Add(enemy);
        monster.SetActive(true);
        map.createEnemy(monster);
        return monster;
    }

    //生成传送门
    public GameObject createrDoolMonster(GameObject MonsterClone)
    {
        if (MonsterClone == null)
        {
            return null;
        }

        addCount++;
        GameObject monster = MyUtils.LoadModelPrefab(MonsterClone.name);
        //GameObject monster = GameObject.Instantiate(MonsterClone);
        Enemy enemy = monster.GetComponent<Enemy>();
        monster.name = monster.name + addCount;
        monsterList.Add(enemy);


        //生成门
        EnemyDool enemyDool = getEnemyDool();
        enemyDool.showDoll(enemy);
        map.createEnemy(monster);
        return monster;
    }

    public void createrMonster(string path, GameObject parent)
    {
        if (string.IsNullOrEmpty(path))
        {
            return;
        }
        GameObject monster = MyUtils.LoadModelPrefab(path);
        if (monster == null)
            return;
        addCount++;
        monster.transform.forward = CameraManager.Instance.Player.forward;
        monster.transform.position = parent.transform.position;
        monster.name = path + addCount;
        monster.transform.LookAt(CameraManager.Instance.Player);
        monsterList.Add(monster.GetComponent<Enemy>());
        monster.SetActive(true);
        map.createEnemy(monster);

    }
    public void destoryAll()
    {
        int count = monsterList.Count - 1;
        for (int i = count; i >=0; i--)
        {
            if (monsterList[i] == null)
                continue;
            monsterList[i].Dead();
        }
        monsterList.Clear();
    }
    public Map map
    {
        get
        {
            if (_map == null)
            {
                GameObject obj = GameObject.FindGameObjectWithTag(Tags.Map);
                if (obj != null)
                    _map = obj.GetComponent<Map>();
            }
            return _map;
        }
    }
    public void addScore(int score)
    {
        map.addScore(score);
    }
    public void destoy(GameObject obj)
    {

        for (int i = 0; i < monsterList.Count; i++)
        {
            if (monsterList[i] == null)
            {
                continue;
            }
            if (obj == monsterList[i].gameObject)
            {
                monsterList.RemoveAt(i);
                break;
            }
        }
      //  Debug.Log(monsterList.Count);
        map.destroy(obj.name);
    }

    public List<Enemy> getMonsterList
    {
        get
        {
            return monsterList;
        }
    }
    public int getCreatenum
    {
        get
        {
            return addCount;
        }
    }

    //从缓存的无用子弹中获取子弹
    private EnemyDool getEnemyDool()
    {
       GameObject obj= ResourceManagerPool.Instance.GetPoolObject("blackHole", ResourceType.effect, true);
        return obj.GetComponent<EnemyDool>();
    }
    //创建子弹
    private EnemyDool createEnemyDool()
    {

        GameObject cloneEnemyDool = MyUtils.LoadEffectPrefab("blackHole", false);
        cloneEnemyDool.name = cloneEnemyDool.name;
        EnemyDool obj = cloneEnemyDool.GetComponent<EnemyDool>();
        obj.transform.localScale = Vector3.one;
        obj.gameObject.SetActive(false);
        return obj;
    }
} 

