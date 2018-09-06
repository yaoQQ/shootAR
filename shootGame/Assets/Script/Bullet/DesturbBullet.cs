using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

public class DesturbBullet : MonoBehaviour
{
    public float explosionDistance = 2;//爆炸范围
    public float desturbTime = 2;//干扰持续时间

    public string desturbEffect;
    public void Start()
    {
        shoot();
    }
    public void shoot()
    {
        //List<GameObject> enemys = MyUtils.CalculateEnemiesByDistance(MonsterManager.Instance.getMonsterList, explosionDistance, this.transform.position);
        //for (int i = 0; i < enemys.Count; i++)
        //{
        //    if (enemys[i] == null)
        //    {
        //        continue;
        //    }
        //    Enemy enemy = enemys[i].GetComponent<Enemy>();
        //    enemy.stopAttrackTime(desturbTime);
        //    GameObject DesturbEffect = MyUtils.LoadEffectPrefab(desturbEffect);
        //    DesturbEffect.transform.parent = enemy.transform;
        //    DesturbEffect.transform.localPosition = Vector3.zero;
        //    GameObject.Destroy(DesturbEffect.gameObject, desturbTime);
        //}
        MonsterManager.Instance.destoryAll();
    }
}

